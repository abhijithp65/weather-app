import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherConditionHelper {
  WeatherConditionHelper._();

  static List<Color> gradient(int id, bool isDay) {
    if (id >= 200 && id < 300) return AppColors.stormy;
    if (id >= 300 && id < 600) return AppColors.rainy;
    if (id >= 600 && id < 700) return AppColors.snowy;
    if (id >= 700 && id < 800) return AppColors.foggy;
    if (id == 800) return isDay ? AppColors.clearDay : AppColors.clearNight;
    if (id > 800) return AppColors.cloudy;
    return AppColors.clearDay;
  }

  static String emoji(int id, bool isDay) {
    if (id >= 200 && id < 300) return '⛈️';
    if (id >= 300 && id < 400) return '🌦️';
    if (id >= 500 && id < 600) return '🌧️';
    if (id >= 600 && id < 700) return '❄️';
    if (id >= 700 && id < 800) return '🌫️';
    if (id == 800) return isDay ? '☀️' : '🌙';
    if (id == 801) return isDay ? '🌤️' : '☁️';
    if (id == 802) return '⛅';
    if (id >= 803) return '☁️';
    return isDay ? '🌤️' : '🌙';
  }

  static String smallEmoji(String iconCode) {
    final base = iconCode.replaceAll('n', 'd');
    const Map<String, String> map = {
      '01d': '☀️', '02d': '🌤️', '03d': '⛅', '04d': '☁️',
      '09d': '🌧️', '10d': '🌦️', '11d': '⛈️', '13d': '❄️', '50d': '🌫️',
    };
    return map[base] ?? '🌡️';
  }

  static String windDirection(int deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((deg + 22.5) ~/ 45) % 8];
  }
}
