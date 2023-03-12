import 'package:weather/bloc/weather_event.dart';
import 'package:weather/bloc/weather_states.dart';
import 'package:weather/services/geocoding_service.dart';
import 'package:weather/services/storage_service.dart';
import '../models/place_model.dart';
import '../services/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<ChangeWeatherEvent>(emitWeather);
  }

  void emitWeather(ChangeWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    Place? place = await StorageService.findInStorage(event.placeName);
    place ??= await GeocodingService.getCoordinates(event.placeName);
    if (place == null) {
      emit(WeatherError());
      return;
    }
    if (event.placeName != 'lastViewed') {
      await StorageService.updateLastViewed(place);
    }
    final weathers =
        await WeatherRepository.updateWeather(place.lat, place.lon);
    if (weathers != null) {
      emit(WeatherSuccess(weathers));
    } else {
      emit(WeatherError());
    }
  }
}