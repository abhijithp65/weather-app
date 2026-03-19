import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_day.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/weather_condition_helper.dart';

class ForecastList extends StatelessWidget {
  final List<ForecastDay> forecast;
  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white20, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.white50, size: 16),
                const SizedBox(width: 6),
                Text('5-DAY FORECAST', style: AppTextStyles.detailLabel),
              ],
            ),
          ),
          const Divider(color: AppColors.white20, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecast.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.white20, height: 1),
            itemBuilder: (context, i) => _ForecastRow(day: forecast[i]),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final ForecastDay day;
  const _ForecastRow({required this.day});

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE').format(day.date);
    final emoji   = WeatherConditionHelper.smallEmoji(day.iconCode);
    final popPct  = (day.pop * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(dayName, style: AppTextStyles.forecastDay),
          ),
          Expanded(
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                if (popPct > 20) ...[
                  const SizedBox(width: 6),
                  Text(
                    '$popPct%',
                    style: AppTextStyles.forecastDay.copyWith(
                      color: const Color(0xFF90CDF4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            children: [
              Text('${day.tempMax.round()}°', style: AppTextStyles.forecastTemp),
              const SizedBox(width: 8),
              Text('${day.tempMin.round()}°', style: AppTextStyles.forecastTempLow),
            ],
          ),
        ],
      ),
    );
  }
}
