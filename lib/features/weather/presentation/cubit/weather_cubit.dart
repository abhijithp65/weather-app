import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants.dart';
import '../../domain/usecases/weather_usecases.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetCurrentWeatherByLocation _byLocation;
  final GetCurrentWeatherByCity _byCity;
  final GetForecastByLocation _forecastByLocation;
  final GetForecastByCity _forecastByCity;

  WeatherCubit({
    required GetCurrentWeatherByLocation byLocation,
    required GetCurrentWeatherByCity byCity,
    required GetForecastByLocation forecastByLocation,
    required GetForecastByCity forecastByCity,
  })  : _byLocation = byLocation,
        _byCity = byCity,
        _forecastByLocation = forecastByLocation,
        _forecastByCity = forecastByCity,
        super(const WeatherInitial());

  Future<void> loadByLocation() async {
    emit(const WeatherLoading());
    final current  = await _byLocation();
    final forecast = await _forecastByLocation();
    current.fold(
      (f) => emit(WeatherError(f.message)),
      (c) => forecast.fold(
        (f) => emit(WeatherError(f.message)),
        (fc) {
          emit(WeatherLoaded(current: c, forecast: fc));
          _saveLastCity(c.cityName);
        },
      ),
    );
  }

  Future<void> loadByCity(String city) async {
    if (city.trim().isEmpty) return;
    emit(const WeatherLoading());
    final current  = await _byCity(city.trim());
    final forecast = await _forecastByCity(city.trim());
    current.fold(
      (f) => emit(WeatherError(f.message)),
      (c) => forecast.fold(
        (f) => emit(WeatherError(f.message)),
        (fc) {
          emit(WeatherLoaded(current: c, forecast: fc));
          _saveLastCity(c.cityName);
        },
      ),
    );
  }

  Future<void> loadLastCity() async {
    final prefs    = await SharedPreferences.getInstance();
    final lastCity = prefs.getString(AppConstants.lastCityKey);
    if (lastCity != null) {
      await loadByCity(lastCity);
    } else {
      await loadByLocation();
    }
  }

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.lastCityKey, city);
  }
}
