import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/appointment/domain/usecases/get_comments_by_business.dart';
import 'package:service_now/features/appointment/domain/usecases/get_galleries_by_business.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _subscription;
  final GetBusinessByCategory getBusinessByCategory;
  final GetGalleriesByBusiness getGalleriesByBusiness;
  final GetCommentsByBusiness getCommentsByBusiness;

  AppointmentBloc({
    @required GetBusinessByCategory business,
    @required GetGalleriesByBusiness galleries,
    @required GetCommentsByBusiness comments
  }) : assert(business != null, galleries != null),
       getBusinessByCategory = business,
       getGalleriesByBusiness = galleries,
       getCommentsByBusiness = comments {
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
      final failureOrBusiness = await getBusinessByCategory(GetBusinessParams(categoryId: event.categoryId, latitude: event.latitude, longitude: event.longitude));
      yield* _eitherLoadedBusinessOrErrorState(failureOrBusiness);
    } else if (event is GetGalleriesForUser) {
      this.state.copyWith(status: BusinessStatus.loadingGallery, galleries: []);
      final failureOrGalleries = await getGalleriesByBusiness(GetGalleriesParams(businessId: event.businessId));
      yield* _eitherLoadedGalleriesOrErrorState(failureOrGalleries);
    } else if (event is GetCommentsForUser) {
      final failureOrComments = await getCommentsByBusiness(GetCommentsParams(businessId: event.businessId));
      yield* _eitherLoadedCommentsOrErrorState(failureOrComments);
    }
  }

  Stream<AppointmentState> _eitherLoadedBusinessOrErrorState(
    Either<Failure, List<Business>> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, business: []);
      },
      (business) {
        final markers = Map<MarkerId, Marker>.from(this.state.markers);

        if (state.status == BusinessStatus.ready) {
          for (var trade in state.business) {
            final markerId = MarkerId(trade.id.toString());
            final marker = Marker(markerId: markerId, position: LatLng(double.parse(trade.latitude), double.parse(trade.longitude)));

            markers[markerId] = marker;
          }
        }

        return this.state.copyWith(status: BusinessStatus.ready, business: business, markers: markers);
      }
    );
  }

  Stream<AppointmentState> _eitherLoadedGalleriesOrErrorState(
    Either<Failure, List<Gallery>> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, galleries: []);
      },
      (galleries) {
        return this.state.copyWith(status: BusinessStatus.readyGallery, galleries: galleries);
      }
    );
  }

  Stream<AppointmentState> _eitherLoadedCommentsOrErrorState(
    Either<Failure, List<Comment>> failureOrComments
  ) async * {
    yield failureOrComments.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, comments: []);
      },
      (comments) {
        return this.state.copyWith(status: BusinessStatus.readyComments, comments: comments);
      }
    );
  }

  static AppointmentBloc of(BuildContext context) {
    return BlocProvider.of<AppointmentBloc>(context);
  }
}