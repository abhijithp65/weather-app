import 'package:equatable/equatable.dart';

class ForecastDay extends Equatable {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final int conditionId;
  final String conditionDescription;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final double pop;

  const ForecastDay({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.conditionId,
    required this.conditionDescription,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  @override
  List<Object> get props => [date, tempMin, tempMax, conditionId];
}
