import 'package:flutter/material.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/bloc/weather_bloc_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_event.dart';
import 'package:weather/views/drawer.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherBloc>(
        create: (_) =>
            WeatherBloc()..add(const ChangeWeatherEvent('lastViewed')),
        child: Builder(
            builder: (context) => Scaffold(
                  drawer: MyDrawer(context, addEventToBloc),
                  backgroundColor: const Color.fromARGB(255, 200, 200, 255),
                  appBar: AppBar(
                    title: Container(
                      color: Colors.white,
                      child: TextField(
                        controller: _inputController,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        iconSize: 35,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          addEventToBloc(
                              context, _inputController.text.toLowerCase());
                          _inputController.clear();
                        },
                      ),
                    ],
                  ),
                  body: Column(children: const [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Expanded(child: WeatherBlocBuilder())
                  ]),
                )));
  }

  void addEventToBloc(BuildContext context, String place) {
    BlocProvider.of<WeatherBloc>(context).add(ChangeWeatherEvent(place));
  }
}
