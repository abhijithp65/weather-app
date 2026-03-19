import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/weather_condition_helper.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/weather_detail_grid.dart';
import '../widgets/weather_search_bar.dart';
import '../widgets/weather_state_widgets.dart';
import 'api_key_screen.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;
  List<Color> _currentGradient = AppColors.clearDay;
  List<Color> _nextGradient = AppColors.clearDay;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _gradientAnimation = CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    );
    context.read<WeatherCubit>().loadLastCity();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  void _updateGradient(List<Color> newGradient) {
    if (newGradient == _nextGradient) return;
    setState(() {
      _currentGradient = _nextGradient;
      _nextGradient = newGradient;
    });
    _gradientController
      ..reset()
      ..forward();
  }

  Future<void> _changeApiKey() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApiKeyScreen(
          onKeySaved: () {
            Navigator.of(context).pop();
            context.read<WeatherCubit>().loadLastCity();
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state is WeatherLoaded) {
          _updateGradient(
            WeatherConditionHelper.gradient(
              state.current.conditionId,
              state.current.isDay,
            ),
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            final t = _gradientAnimation.value;
            final colors = [
              Color.lerp(_currentGradient[0], _nextGradient[0], t)!,
              Color.lerp(_currentGradient[1], _nextGradient[1], t)!,
            ];
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<WeatherCubit, WeatherState>(
                          builder: (context, state) => WeatherSearchBar(
                            isLoading: state is WeatherLoading,
                            onSearch: (city) =>
                                context.read<WeatherCubit>().loadByCity(city),
                            onLocationTap: () =>
                                context.read<WeatherCubit>().loadByLocation(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _changeApiKey,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white10,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.white20,
                              width: 0.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.key_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherInitial) {
                        return WeatherInitialWidget(
                          onLocationTap: () =>
                              context.read<WeatherCubit>().loadByLocation(),
                        );
                      }
                      if (state is WeatherLoading) {
                        return const WeatherLoadingWidget();
                      }
                      if (state is WeatherError) {
                        return WeatherErrorWidget(
                          message: state.message,
                          onRetry: () =>
                              context.read<WeatherCubit>().loadLastCity(),
                        );
                      }
                      if (state is WeatherLoaded) {
                        return _WeatherContent(state: state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherLoaded state;
  const _WeatherContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<WeatherCubit>().loadByCity(state.current.cityName),
      color: Colors.white,
      backgroundColor: AppColors.black30,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: CurrentWeatherCard(weather: state.current),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
              child: ForecastList(forecast: state.forecast),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: WeatherDetailGrid(weather: state.current),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
