import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

class Weather {
  String? cityName;
  int? temp;
  String? icon;
  String? main;

  Weather([this.cityName, this.temp, this.icon, this.main]);
}

class FormattedDate {
  String formatDate(String date) {
    DateTime dateObj = DateTime.parse(date);
    return "${DateFormat('EEEE').format(dateObj)}, ${dateObj.day} of ${DateFormat('MMMM').format(dateObj)}";
  }
}

class ExtendedWeather extends Weather with FormattedDate {
  int? feels_like;
  String? formattedDate;
  ExtendedWeather(
      [super.cityName,
      super.temp,
      this.feels_like,
      super.icon,
      super.main,
      this.formattedDate]);

  ExtendedWeather.fromJson(jsonData, String cityName) {
    final Temperature temperature = Temperature.fromJson(jsonData['main']);
    final Description description =
        Description.fromJson(jsonData['weather'][0]);
    this.cityName = cityName;
    temp = temperature.temp.round();
    feels_like = temperature.feels_like.round();
    icon = description.icon;
    main = description.main;
    formattedDate = formatDate(jsonData['dt_txt']);
  }
}

@JsonSerializable()
class Temperature {
  final double temp;
  final double feels_like;
  Temperature(this.temp, this.feels_like);

  factory Temperature.fromJson(json) => _$TemperatureFromJson(json);
}

@JsonSerializable()
class Description {
  final String icon;
  final String main;
  Description(this.icon, this.main);

  factory Description.fromJson(json) => _$DescriptionFromJson(json);
}

abstract class GettingWeather {
  static fetchWeather() async {}
}
