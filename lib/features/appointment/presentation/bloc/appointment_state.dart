import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class AppointmentState extends Equatable {
  final LatLng myLocation;
  final bool loading;

  AppointmentState({ this.myLocation, this.loading = true });

  AppointmentState copyWith({ LatLng myLocation, bool loading }) {
    return AppointmentState(
      myLocation: myLocation ?? this.myLocation,
      loading: loading ?? this.loading
    );
  }

  @override
  List<Object> get props => [myLocation, loading];
}