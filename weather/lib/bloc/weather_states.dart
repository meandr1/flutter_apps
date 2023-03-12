import 'package:weather/models/weather_model.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  @override
List<Object> get props => [];
}

class WeatherLoading extends WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherError extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final List<ExtendedWeather> weathers;
  WeatherSuccess(this.weathers);
  @override
  List<Object> get props => [weathers];
}