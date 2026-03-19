class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String currentPath = '/weather';
  static const String forecastPath = '/forecast';
  static const String units = 'metric';
  static const String lang = 'en';
  static const String apiKeyPrefKey = 'owm_api_key';

  static String iconUrl(String code) =>
      'https://openweathermap.org/img/wn/$code@2x.png';
}

class AppConstants {
  AppConstants._();
  static const String lastCityKey = 'last_city';
}
