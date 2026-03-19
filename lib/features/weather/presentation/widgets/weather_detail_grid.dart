import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/weather_condition_helper.dart';

class WeatherDetailGrid extends StatelessWidget {
  final CurrentWeather weather;
  const WeatherDetailGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final sunriseTime = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000),
    );
    final sunsetTime = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000),
    );
    final visKm  = (weather.visibility / 1000).toStringAsFixed(1);
    final windDir = WeatherConditionHelper.windDirection(weather.windDeg);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white20, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.6,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _DetailTile(icon: '💧', label: 'HUMIDITY',   value: '${weather.humidity}%'),
          _DetailTile(icon: '💨', label: 'WIND',       value: '${weather.windSpeed.round()} m/s $windDir'),
          _DetailTile(icon: '👁️', label: 'VISIBILITY', value: '$visKm km'),
          _DetailTile(icon: '🌡️', label: 'FEELS LIKE', value: '${weather.feelsLike.round()}°C'),
          _DetailTile(icon: '🌅', label: 'SUNRISE',    value: sunriseTime),
          _DetailTile(icon: '🌇', label: 'SUNSET',     value: sunsetTime),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.detailLabel),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.detailValue),
      ],
    );
  }
}
