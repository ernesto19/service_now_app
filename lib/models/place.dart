import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class Place {
  final String id;
  final String title;
  final LatLng position;
  final String vicinity;

  Place({ @required this.id, @required this.title, @required this.position, @required this.vicinity });

  factory Place.fromJson(dynamic json) {
    // final coords = List<double>.from(json['position']);
    // final coords = List<double>.from(json['geometry']['location']);
    final coords = Location.fromJson(json['geometry']['location']);

    return Place(
      // id: json['id'],
      id: json['place_id'],
      // title: json['title'], 
      title: json['name'], 
      // position: LatLng(coords[0], coords[1]),
      position: LatLng(coords.lat, coords.lng),
      // vicinity: json['vicinity'] ?? ''
      vicinity: json['formatted_address'] ?? ''
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({ @required this.lat, @required this.lng });

  factory Location.fromJson(dynamic json) {
    return Location(
      lat: json['lat'],
      lng: json['lng']
    );
  }
}

class PlaceResponse {
  List<Place> places = List();

  PlaceResponse.fromJson(dynamic json) {
    if (json == null) return;

    for (var item in json['results']) {
      if (item['geometry']['location'] != null) {
        final place = Place.fromJson(item);
        places.add(place);
      }
    }
  }
}