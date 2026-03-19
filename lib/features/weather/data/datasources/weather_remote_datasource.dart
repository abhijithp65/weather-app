import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constants.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherModel> getCurrentWeatherByCoords(double lat, double lon);
  Future<CurrentWeatherModel> getCurrentWeatherByCity(String city);
  Future<List<ForecastModel>> getForecastByCoords(double lat, double lon);
  Future<List<ForecastModel>> getForecastByCity(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;
  WeatherRemoteDataSourceImpl(this._dio);

  Future<String> _apiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key   = prefs.getString(ApiConstants.apiKeyPrefKey) ?? '';
    if (key.isEmpty) throw Exception('API key not set.');
    return key;
  }

  @override
  Future<CurrentWeatherModel> getCurrentWeatherByCoords(double lat, double lon) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.currentPath}',
      queryParameters: {
        'lat': lat, 'lon': lon,
        'appid': await _apiKey(),
        'units': ApiConstants.units,
        'lang':  ApiConstants.lang,
      },
    );
    return CurrentWeatherModel.fromJson(response.data);
  }

  @override
  Future<CurrentWeatherModel> getCurrentWeatherByCity(String city) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.currentPath}',
      queryParameters: {
        'q': city,
        'appid': await _apiKey(),
        'units': ApiConstants.units,
        'lang':  ApiConstants.lang,
      },
    );
    return CurrentWeatherModel.fromJson(response.data);
  }

  @override
  Future<List<ForecastModel>> getForecastByCoords(double lat, double lon) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.forecastPath}',
      queryParameters: {
        'lat': lat, 'lon': lon,
        'appid': await _apiKey(),
        'units': ApiConstants.units,
        'lang':  ApiConstants.lang,
        'cnt':   40,
      },
    );
    return ForecastModel.fromForecastJson(response.data);
  }

  @override
  Future<List<ForecastModel>> getForecastByCity(String city) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.forecastPath}',
      queryParameters: {
        'q': city,
        'appid': await _apiKey(),
        'units': ApiConstants.units,
        'lang':  ApiConstants.lang,
        'cnt':   40,
      },
    );
    return ForecastModel.fromForecastJson(response.data);
  }
}
