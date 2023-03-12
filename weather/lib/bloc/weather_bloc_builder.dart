import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/views/weather_widget_list.dart';
import 'weather_bloc.dart';
import 'weather_states.dart';

class WeatherBlocBuilder extends StatelessWidget {
  const WeatherBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is WeatherError) {
        return const Center(
          child: Icon(Icons.close),
        );
      } else if (state is WeatherSuccess) {
        return WeatherList(state.weathers).getWeatherList();
      } else {
        return Container();
      }
    });
  }
}
