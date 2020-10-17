import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class Place {
  final String id;
  final String title;
  final LatLng position;
  final String vicinity;

  Place({ @required this.id, @required this.title, @required this.position, @required this.vicinity });

  factory Place.fromJson(dynamic json) {
    final coords = List<double>.from(json['position']);

    return Place(
      id: json['id'],
      title: json['title'], 
      position: LatLng(coords[0], coords[1]),
      vicinity: json['vicinity'] ?? ''
    );
  }
}

class PlaceResponse {
  List<Place> places = List();

  PlaceResponse.fromJson(dynamic json) {
    if (json == null) return;

    for (var item in json['results']) {
      if (item['position'] != null) {
        final place = Place.fromJson(item);
        places.add(place);
      }
    }
  }
}