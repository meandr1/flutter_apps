import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/place_model.dart';
import 'package:weather/services/storage_service.dart';
import '../api_keys.dart';

class GeocodingService {
  static final String _apiKey = Keys().getGeoAPIKey();

  static Future<Place?> getCoordinates(String cityName) async {
    if (cityName == 'lastViewed') return null;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$_apiKey&language=en';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      Place place = Place.fromJson(json['results'][0]);
      await StorageService.addToStorage(place, cityName);
      return place;
    } else {
      print('Location not found');
      return null;
    }
  }
}
