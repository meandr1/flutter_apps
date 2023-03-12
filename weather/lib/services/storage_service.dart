import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:weather/models/place_model.dart';

class StorageService {
  static Future<Place?> findInStorage(String placeName) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Places'));
    parseQuery.whereContains('Place', placeName);
    final ParseResponse apiResponse = await parseQuery.query();
    return Place.fromString(apiResponse.results?[0]['Details']);
  }

  static Future<List<String?>?> getPlaces() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Places'));

    final ParseResponse apiResponse = await parseQuery.query();

    return apiResponse.results
        ?.map((item) => Place.fromString(item['Details'])?.name)
        .toSet()
        .toList();
  }

  static addToStorage(Place place, String placeName) async {
    final parseObj = ParseObject('Places')
      ..set('Place', placeName)
      ..set('Details', place.toString());
    await parseObj.save();
  }

  static updateLastViewed(Place place) async {
    final lastViewedID = await getLastViewedID();
    final parseObj = ParseObject('Places')
      ..objectId = lastViewedID
      ..set('Place', 'lastViewed')
      ..set('Details', place.toString());
    await parseObj.save();
  }

  static Future<String?> getLastViewedID() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Places'));
    parseQuery.whereContains('Place', 'lastViewed');
    final ParseResponse apiResponse = await parseQuery.query();
    return apiResponse.results?[0].objectId;
  }
}
