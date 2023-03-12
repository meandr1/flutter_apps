import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../api_keys.dart';

class WeatherService implements GettingWeather {
  static final String _apiKey = Keys().getWeatherAPIKey();

  static Future<List<ExtendedWeather>> fetchWeather(
      String lat, String long) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<ExtendedWeather> weatherData = [];
      final today = DateTime.parse(jsonData['list'][0]['dt_txt']).day;
      final String cityName = jsonData['city']['name'];

      for (int i = 0; i < jsonData['list'].length; i++) {
        DateTime date = DateTime.parse(jsonData['list'][i]['dt_txt']);
        if (i == 0 || (date.day != today && date.hour == 12)) {
          weatherData
              .add(ExtendedWeather.fromJson(jsonData['list'][i], cityName));
        }
      }
      return weatherData;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
