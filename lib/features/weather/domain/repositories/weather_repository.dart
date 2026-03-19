import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/current_weather.dart';
import '../entities/forecast_day.dart';

abstract class WeatherRepository {
  Future<Either<Failure, CurrentWeather>> getCurrentWeatherByLocation();
  Future<Either<Failure, CurrentWeather>> getCurrentWeatherByCity(String city);
  Future<Either<Failure, List<ForecastDay>>> getForecastByLocation();
  Future<Either<Failure, List<ForecastDay>>> getForecastByCity(String city);
}
