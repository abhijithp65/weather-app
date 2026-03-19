import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/weather/data/datasources/location_datasource.dart';
import 'features/weather/data/datasources/weather_remote_datasource.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/weather_usecases.dart';
import 'features/weather/presentation/cubit/weather_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Accept': 'application/json'},
        ),
      ));

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remote: sl<WeatherRemoteDataSource>(),
      location: sl<LocationDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => GetCurrentWeatherByLocation(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => GetCurrentWeatherByCity(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => GetForecastByLocation(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => GetForecastByCity(sl<WeatherRepository>()));

  sl.registerFactory(() => WeatherCubit(
        byLocation: sl<GetCurrentWeatherByLocation>(),
        byCity: sl<GetCurrentWeatherByCity>(),
        forecastByLocation: sl<GetForecastByLocation>(),
        forecastByCity: sl<GetForecastByCity>(),
      ));
}
