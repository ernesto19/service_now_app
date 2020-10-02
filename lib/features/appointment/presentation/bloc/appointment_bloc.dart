import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:service_now/features/appointment/presentation/bloc/appointment_events.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvents, AppointmentState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _subscription;

  AppointmentBloc() {
    this._init();
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    super.close();
  }

  _init() async {
    _subscription = _geolocator.getPositionStream(_locationOptions).listen((position) {
      if (position != null) {
        add(OnMyLocationUpdate(LatLng(position.latitude, position.longitude)));
      }
    });
  }

  @override
  AppointmentState get initialState => AppointmentState();

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvents event) async* {
    if (event is OnMyLocationUpdate) {
      yield this.state.copyWith(loading: false, myLocation: event.location);
    }
  }  
}