import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/weather_condition_helper.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;
  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final emoji = WeatherConditionHelper.emoji(weather.conditionId, weather.isDay);
    final now   = DateFormat('EEEE, d MMM').format(weather.dateTime);

    return Column(
      children: [
        Text(now, style: AppTextStyles.feelsLike),
        const SizedBox(height: 24),
        Text(emoji, style: const TextStyle(fontSize: 96)),
        const SizedBox(height: 8),
        Text('${weather.temperature.round()}°', style: AppTextStyles.temperature),
        Text(
          _capitalize(weather.conditionDescription),
          style: AppTextStyles.condition,
        ),
        const SizedBox(height: 4),
        Text(
          'Feels like ${weather.feelsLike.round()}°  •  H:${weather.tempMax.round()}°  L:${weather.tempMin.round()}°',
          style: AppTextStyles.feelsLike,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded,
                color: AppColors.white70, size: 16),
            const SizedBox(width: 4),
            Text(
              '${weather.cityName}, ${weather.country}',
              style: AppTextStyles.cityName,
            ),
          ],
        ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
