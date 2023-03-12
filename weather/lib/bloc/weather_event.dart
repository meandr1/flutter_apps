import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object> get props => [];
}

class ChangeWeatherEvent extends WeatherEvent {
  final String placeName;
  const ChangeWeatherEvent(this.placeName);
}
