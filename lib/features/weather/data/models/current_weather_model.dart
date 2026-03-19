import '../../domain/entities/current_weather.dart';

class CurrentWeatherModel extends CurrentWeather {
  const CurrentWeatherModel({
    required super.cityName,
    required super.country,
    required super.temperature,
    required super.feelsLike,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.windSpeed,
    required super.windDeg,
    required super.conditionId,
    required super.conditionMain,
    required super.conditionDescription,
    required super.iconCode,
    required super.sunrise,
    required super.sunset,
    required super.visibility,
    required super.lat,
    required super.lon,
    required super.dateTime,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first;
    final main    = json['main'];
    final wind    = json['wind'];
    final sys     = json['sys'];
    final coord   = json['coord'];

    return CurrentWeatherModel(
      cityName:             json['name'] ?? '',
      country:              sys['country'] ?? '',
      temperature:          (main['temp'] as num).toDouble(),
      feelsLike:            (main['feels_like'] as num).toDouble(),
      tempMin:              (main['temp_min'] as num).toDouble(),
      tempMax:              (main['temp_max'] as num).toDouble(),
      humidity:             (main['humidity'] as num).toInt(),
      windSpeed:            (wind['speed'] as num).toDouble(),
      windDeg:              ((wind['deg'] ?? 0) as num).toInt(),
      conditionId:          (weather['id'] as num).toInt(),
      conditionMain:        weather['main'] ?? '',
      conditionDescription: weather['description'] ?? '',
      iconCode:             weather['icon'] ?? '01d',
      sunrise:              (sys['sunrise'] as num).toInt(),
      sunset:               (sys['sunset'] as num).toInt(),
      visibility:           ((json['visibility'] ?? 10000) as num).toInt(),
      lat:                  (coord['lat'] as num).toDouble(),
      lon:                  (coord['lon'] as num).toDouble(),
      dateTime:             DateTime.fromMillisecondsSinceEpoch(
                              (json['dt'] as num).toInt() * 1000),
    );
  }
}
