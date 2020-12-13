import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/appointment/data/responses/get_business_response.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/models/place.dart';
import 'package:service_now/preferences/user_preferences.dart';

class SearchAPI {
  SearchAPI._internal();
  static SearchAPI get instance => SearchAPI._internal();

  final http.Client client = http.Client();

  Future<List<Place>> searchPlace(String query, LatLng at) async {
    final response = await client.get(
      // 'https://places.ls.hereapi.com/places/v1/autosuggest'
      // + '?q=$query'
      // + '&at=${at.latitude},${at.longitude}'
      // + '&apiKey=e8lPt1YPrnGBKhlf2IZHLqxXX7mvRT5qD2GnHiLc8UQ'
      'https://maps.googleapis.com/maps/api/place/textsearch/json'
      + '?query=$query'
      + '&location=${at.latitude},${at.longitude}'
      + '&radius=10000'
      + '&key=AIzaSyAQdtC9uL--5mlAEHC6W-niIeWKUCpE2Cc'
    );

    if (response.statusCode == 200) {
      final body = PlaceResponse.fromJson(json.decode(response.body));
      return body.places;
    } else {
      return List();
    }
  }

  Future<List<Business>> searchBusiness(String query, LatLng at) async {
    final response = await client.get(
      ApiBaseHelper().baseUrl + 'business/search_business'
      + '?string=$query'
      + '&lat=${at.latitude}'
      + '&long=${at.longitude}',
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetBusinessResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      return List();
    }
  }
}