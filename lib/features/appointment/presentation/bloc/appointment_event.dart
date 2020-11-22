import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';

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

class GoToPlace extends AppointmentEvent {
  final Business trade;
  final BuildContext context;

  GoToPlace(this.trade, this.context);
}

class GetRequestServicesForUser extends AppointmentEvent {
  final Map<String, dynamic> services;

  GetRequestServicesForUser(this.services);
}

class OnSelectedServiceEvent extends AppointmentEvent {
  final int id;

  OnSelectedServiceEvent(this.id);
}

class RequestBusinessForUser extends AppointmentEvent {
  final int businessId;
  final BuildContext context;

  RequestBusinessForUser(this.businessId, this.context);
}