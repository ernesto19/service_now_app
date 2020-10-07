import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AppointmentEvent { }

class OnMyLocationUpdate extends AppointmentEvent {
  final LatLng location;

  OnMyLocationUpdate(this.location);
}

class GetBusinessForUser extends AppointmentEvent {
  final int categoryId;
  final String latitude;
  final String longitude;

  GetBusinessForUser(this.categoryId, this.latitude, this.longitude);
}

class GetGalleriesForUser extends AppointmentEvent {
  final int businessId;

  GetGalleriesForUser(this.businessId);
}

class GetCommentsForUser extends AppointmentEvent {
  final int businessId;

  GetCommentsForUser(this.businessId);
}