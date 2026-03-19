import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int conditionId;
  final String conditionMain;
  final String conditionDescription;
  final String iconCode;
  final int sunrise;
  final int sunset;
  final int visibility;
  final double lat;
  final double lon;
  final DateTime dateTime;

  const CurrentWeather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.conditionId,
    required this.conditionMain,
    required this.conditionDescription,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
    required this.lat,
    required this.lon,
    required this.dateTime,
  });

  bool get isDay {
    final now = dateTime.millisecondsSinceEpoch ~/ 1000;
    return now >= sunrise && now <= sunset;
  }

  @override
  List<Object> get props => [cityName, temperature, conditionId, dateTime];
}
