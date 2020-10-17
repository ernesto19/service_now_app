import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:service_now/models/place.dart';

class SearchAPI {
  SearchAPI._internal();
  static SearchAPI get instance => SearchAPI._internal();

  final http.Client client = http.Client();

  Future<List<Place>> searchPlace(String query, LatLng at) async {
    final response = await client.get(
      'https://places.ls.hereapi.com/places/v1/autosuggest'
      + '?q=$query'
      + '&at=${at.latitude},${at.longitude}'
      + '&apiKey=e8lPt1YPrnGBKhlf2IZHLqxXX7mvRT5qD2GnHiLc8UQ'
    );

    if (response.statusCode == 200) {
      final body = PlaceResponse.fromJson(json.decode(response.body));
      return body.places;
    } else {
      return List();
    }
  }
}