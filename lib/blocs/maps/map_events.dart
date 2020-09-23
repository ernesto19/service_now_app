import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvents {

}

class OnMyLocationUpdate extends MapEvents {
  final LatLng location;

  OnMyLocationUpdate(this.location);
}