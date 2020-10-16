import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service_now/models/place.dart';

class SearchAPI {
  SearchAPI._internal();
  static SearchAPI get instance => SearchAPI._internal();

  final http.Client client = http.Client();

  Future<List<Place>> searchPlace(String query) async {
    final response = await client.get(
      'https://places.ls.hereapi.com/places/v1/autosuggest?q=$query&apiKey=e8lPt1YPrnGBKhlf2IZHLqxXX7mvRT5qD2GnHiLc8UQ&at=-12.1403004,-76.9545776',
    );

    if (response.statusCode == 200) {
      final body = PlaceResponse.fromJson(json.decode(response.body));
      return body.places;
    } else {
      return List();
    }
  }
}