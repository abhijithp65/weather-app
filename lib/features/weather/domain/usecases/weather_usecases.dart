import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/current_weather.dart';
import '../entities/forecast_day.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherByLocation {
  final WeatherRepository _repo;
  GetCurrentWeatherByLocation(this._repo);
  Future<Either<Failure, CurrentWeather>> call() =>
      _repo.getCurrentWeatherByLocation();
}

class GetCurrentWeatherByCity {
  final WeatherRepository _repo;
  GetCurrentWeatherByCity(this._repo);
  Future<Either<Failure, CurrentWeather>> call(String city) =>
      _repo.getCurrentWeatherByCity(city);
}

class GetForecastByLocation {
  final WeatherRepository _repo;
  GetForecastByLocation(this._repo);
  Future<Either<Failure, List<ForecastDay>>> call() =>
      _repo.getForecastByLocation();
}

class GetForecastByCity {
  final WeatherRepository _repo;
  GetForecastByCity(this._repo);
  Future<Either<Failure, List<ForecastDay>>> call(String city) =>
      _repo.getForecastByCity(city);
}
