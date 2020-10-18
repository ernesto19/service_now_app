import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/models/place.dart';

abstract class AddressEvents {}

class OnMyLocationUpdate extends AddressEvents {
  final LatLng location;

  OnMyLocationUpdate(this.location);
}

class GoToPlace extends AddressEvents {
  final Place place;

  GoToPlace(this.place);
}