import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/current_weather.dart';
import '../../domain/entities/forecast_day.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/location_datasource.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remote;
  final LocationDataSource _location;

  WeatherRepositoryImpl({required WeatherRemoteDataSource remote, required LocationDataSource location})
      : _remote = remote,
        _location = location;

  @override
  Future<Either<Failure, CurrentWeather>> getCurrentWeatherByLocation() async {
    try {
      final pos = await _location.getCurrentPosition();
      final weather = await _remote.getCurrentWeatherByCoords(pos.latitude, pos.longitude);
      return Right(weather);
    } on DioException catch (e) {
      return Left(_dioFailure(e));
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CurrentWeather>> getCurrentWeatherByCity(String city) async {
    try {
      return Right(await _remote.getCurrentWeatherByCity(city));
    } on DioException catch (e) {
      return Left(_dioFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ForecastDay>>> getForecastByLocation() async {
    try {
      final pos = await _location.getCurrentPosition();
      return Right(await _remote.getForecastByCoords(pos.latitude, pos.longitude));
    } on DioException catch (e) {
      return Left(_dioFailure(e));
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ForecastDay>>> getForecastByCity(String city) async {
    try {
      return Right(await _remote.getForecastByCity(city));
    } on DioException catch (e) {
      return Left(_dioFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _dioFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('No internet connection. Please try again.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return const ServerFailure('Invalid API key.');
        if (code == 404) return const ServerFailure('City not found.');
        return ServerFailure('Server error ($code).');
      default:
        return ServerFailure(e.message ?? 'Unknown error.');
    }
  }
}
