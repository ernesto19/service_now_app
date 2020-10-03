import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:service_now/features/appointment/domain/entities/business.dart';

enum BusinessStatus { checking, loading, mapMount, selecting, downloading, ready, error }

class AppointmentState extends Equatable {
  final LatLng myLocation;
  final List<Business> business;
  final BusinessStatus status;

  AppointmentState({ this.myLocation, this.business, this.status });

  static AppointmentState get inititalState => AppointmentState(
    myLocation: null,
    business: const [],
    status: BusinessStatus.loading
  );

  AppointmentState copyWith({ 
    LatLng myLocation, 
    List<Business> business,
    BusinessStatus status
  }) {
    return AppointmentState(
      myLocation: myLocation ?? this.myLocation,
      business: business ?? this.business,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [myLocation, business, status];
}