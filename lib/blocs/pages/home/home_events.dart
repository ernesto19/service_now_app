import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/models/place.dart';

abstract class HomeEvents {}

class OnMyLocationUpdate extends HomeEvents {
  final LatLng location;

  OnMyLocationUpdate(this.location);
}

class GoToPlace extends HomeEvents {
  final Place place;

  GoToPlace(this.place);
}