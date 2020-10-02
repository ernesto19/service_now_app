import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AppointmentEvents {

}

class OnMyLocationUpdate extends AppointmentEvents {
  final LatLng location;

  OnMyLocationUpdate(this.location);
}