// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      json['temp'] as double,
      json['feels_like'] as double,
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feels_like,
    };

Description _$DescriptionFromJson(Map<String, dynamic> json) => Description(
      json['icon'] as String,
      json['main'] as String,
    );

Map<String, dynamic> _$DescriptionToJson(Description instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'main': instance.main,
    };
