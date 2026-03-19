import '../../domain/entities/forecast_day.dart';

class ForecastModel extends ForecastDay {
  const ForecastModel({
    required super.date,
    required super.tempMin,
    required super.tempMax,
    required super.conditionId,
    required super.conditionDescription,
    required super.iconCode,
    required super.humidity,
    required super.windSpeed,
    required super.pop,
  });

  static List<ForecastModel> fromForecastJson(Map<String, dynamic> json) {
    final items = (json['list'] as List).cast<Map<String, dynamic>>();

    final Map<String, List<Map<String, dynamic>>> byDay = {};
    for (final item in items) {
      final dt  = DateTime.fromMillisecondsSinceEpoch((item['dt'] as num).toInt() * 1000);
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []).add(item);
    }

    final today    = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final result = <ForecastModel>[];

    for (final entry in byDay.entries) {
      if (entry.key == todayKey) continue;
      if (result.length >= 5) break;

      final dayItems = entry.value;
      final parts    = entry.key.split('-');
      final date     = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));

      double minT        = double.infinity;
      double maxT        = double.negativeInfinity;
      double maxPop      = 0;
      int totalHumidity  = 0;
      double totalWind   = 0;

      Map<String, dynamic>? noonItem;
      int bestDiff = 999;

      for (final item in dayItems) {
        final dt   = DateTime.fromMillisecondsSinceEpoch((item['dt'] as num).toInt() * 1000);
        final diff = (dt.hour - 12).abs();
        if (diff < bestDiff) {
          bestDiff  = diff;
          noonItem  = item;
        }
        final m = item['main'];
        final t = (m['temp'] as num).toDouble();
        if (t < minT) minT = t;
        if (t > maxT) maxT = t;
        maxPop         = [maxPop, ((item['pop'] ?? 0) as num).toDouble()].reduce((a, b) => a > b ? a : b);
        totalHumidity += (m['humidity'] as num).toInt();
        totalWind     += ((item['wind']?['speed'] ?? 0) as num).toDouble();
      }

      final rep     = noonItem ?? dayItems.first;
      final weather = (rep['weather'] as List).first;

      result.add(ForecastModel(
        date:                 date,
        tempMin:              minT == double.infinity ? 0 : minT,
        tempMax:              maxT == double.negativeInfinity ? 0 : maxT,
        conditionId:          (weather['id'] as num).toInt(),
        conditionDescription: weather['description'] ?? '',
        iconCode:             weather['icon'] ?? '01d',
        humidity:             (totalHumidity / dayItems.length).round(),
        windSpeed:            totalWind / dayItems.length,
        pop:                  maxPop,
      ));
    }

    return result;
  }
}
