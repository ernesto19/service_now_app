import 'package:flutter/material.dart';
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
  final BuildContext context;

  GetBusinessForUser(this.categoryId, this.latitude, this.longitude, this.context);
}

class GetGalleriesForUser extends AppointmentEvent {
  final int businessId;

  GetGalleriesForUser(this.businessId);
}

class GetCommentsForUser extends AppointmentEvent {
  final int businessId;

  GetCommentsForUser(this.businessId);
}