import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'features/weather/presentation/cubit/weather_cubit.dart';
import 'features/weather/presentation/pages/api_key_screen.dart';
import 'features/weather/presentation/pages/weather_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await initDependencies();
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool _hasApiKey = false;
  bool _checking  = true;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    final prefs  = await SharedPreferences.getInstance();
    final key    = prefs.getString(ApiConstants.apiKeyPrefKey) ?? '';
    setState(() {
      _hasApiKey = key.isNotEmpty;
      _checking  = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: _checking
          ? const _SplashScreen()
          : _hasApiKey
              ? BlocProvider(
                  create: (_) => sl<WeatherCubit>(),
                  child: const WeatherPage(),
                )
              : ApiKeyScreen(
                  onKeySaved: () => setState(() => _hasApiKey = true),
                ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.clearDay,
          ),
        ),
        child: Center(
          child: Text('🌤️', style: TextStyle(fontSize: 72)),
        ),
      ),
    );
  }
}
