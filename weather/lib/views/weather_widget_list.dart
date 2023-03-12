import 'package:weather/models/weather_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WeatherList {
  final List<ExtendedWeather> weathers;
  WeatherList(this.weathers);

  ListView getWeatherList() {
    return ListView.separated(
        separatorBuilder: (context, index) =>
            const Divider(color: Color.fromARGB(255, 200, 200, 255)),
        itemCount: weathers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Text("Weather forecast for\n${weathers[0].cityName}",
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center);
          }
          return ListTile(
              leading: CachedNetworkImage(
                  imageUrl:
                      "http://openweathermap.org/img/wn/${weathers[index - 1].icon}@2x.png",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
              title: Text(
                  " ${weathers[index - 1].formattedDate}\n ${weathers[index - 1].temp}°C, " +
                      "${weathers[index - 1].main}, feels like ${weathers[index - 1].feels_like}°C",
                  style: const TextStyle(fontSize: 20)));
        });
  }
}
