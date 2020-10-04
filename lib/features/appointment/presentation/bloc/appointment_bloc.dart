import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _subscription;
  final GetBusinessByCategory getBusinessByCategory;

  AppointmentBloc({
    @required GetBusinessByCategory business
  }) : assert(business != null),
       getBusinessByCategory = business {
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
  AppointmentState get initialState => AppointmentState.initialState;

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is OnMyLocationUpdate) {
      yield this.state.copyWith(myLocation: event.location, status: BusinessStatus.mapMount);
    } else if (event is GetBusinessForUser) {
      final failureOrBusiness = await getBusinessByCategory(Params(categoryId: event.categoryId, latitude: event.latitude, longitude: event.longitude));
      yield* _eitherLoadedOrErrorState(failureOrBusiness);
    }
  }

  Stream<AppointmentState> _eitherLoadedOrErrorState(
    Either<Failure, List<Business>> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, business: []);
      },
      (business) {
        return this.state.copyWith(status: BusinessStatus.ready, business: business);
      }
    );
  }

  static AppointmentBloc of(BuildContext context) {
    return BlocProvider.of<AppointmentBloc>(context);
  }
}