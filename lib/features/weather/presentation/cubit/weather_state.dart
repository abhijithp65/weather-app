import 'package:equatable/equatable.dart';
import '../../domain/entities/current_weather.dart';
import '../../domain/entities/forecast_day.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final CurrentWeather current;
  final List<ForecastDay> forecast;
  const WeatherLoaded({required this.current, required this.forecast});
  @override
  List<Object?> get props => [current, forecast];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object?> get props => [message];
}
