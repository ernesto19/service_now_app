import 'dart:async';
import 'dart:typed_data';
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
import 'package:service_now/features/appointment/presentation/pages/business_detail_page.dart';
import 'package:service_now/utils/extras_image.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _subscription;
  final GetBusinessByCategory getBusinessByCategory;
  final GetGalleriesByBusiness getGalleriesByBusiness;
  final GetCommentsByBusiness getCommentsByBusiness;
  Completer<GoogleMapController> _completer = Completer();

  Future<GoogleMapController> get _mapController async {
    return await _completer.future;
  }

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
      if (this.state.status != BusinessStatus.ready) {
        final failureOrBusiness = await getBusinessByCategory(GetBusinessParams(categoryId: event.categoryId, latitude: event.latitude, longitude: event.longitude));
        yield* _eitherLoadedBusinessOrErrorState(failureOrBusiness, event.context);
      }
    } else if (event is GetGalleriesForUser) {
      this.state.copyWith(status: BusinessStatus.loadingGallery, galleries: []);
      final failureOrGalleries = await getGalleriesByBusiness(GetGalleriesParams(businessId: event.businessId));
      yield* _eitherLoadedGalleriesOrErrorState(failureOrGalleries);
    } else if (event is GetCommentsForUser) {
      final failureOrComments = await getCommentsByBusiness(GetCommentsParams(businessId: event.businessId));
      yield* _eitherLoadedCommentsOrErrorState(failureOrComments);
    } else if (event is GoToPlace) {
      final history = Map<String, Business>.from(this.state.history);
      final MarkerId markerId = MarkerId('place');

      final Uint8List bytes = await loadAsset('assets/icons/marker_active.png', width: 130, height: 130);
      final customIcon = BitmapDescriptor.fromBytes(bytes);

      final info = InfoWindow(title: event.trade.name);

      final Marker marker = Marker(
        markerId: markerId, 
        position: LatLng(double.parse(event.trade.latitude), double.parse(event.trade.longitude)),
        icon: customIcon, 
        anchor: Offset(0.5, 1), 
        infoWindow: info,
        onTap: () => this._showMarkerDialog(event.trade, event.context)
      );

      final markers = Map<MarkerId, Marker>.from(this.state.markers);
      markers[markerId] = marker;

      if (history[event.trade.id.toString()] == null) {
        history[event.trade.id.toString()] = event.trade;
        yield this.state.copyWith(history: history, markers: markers, trade: event.trade);
      } else {
        yield this.state.copyWith(markers: markers, trade: event.trade);
      }
    }
  }

  Stream<AppointmentState> _eitherLoadedBusinessOrErrorState(
    Either<Failure, List<Business>> failureOrBusiness, BuildContext context
  ) async * {
    final Uint8List activeIcon = await loadAsset('assets/icons/marker_active.png', width: 130, height: 130);
    final Uint8List inactiveIcon = await loadAsset('assets/icons/marker_inactive.png', width: 130, height: 130);
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, business: []);
      },
      (business) {
        final markers = Map<MarkerId, Marker>.from(this.state.markers);

        if (state.status == BusinessStatus.mapMount) {
          for (var trade in business) {
            final info = InfoWindow(title: trade.name);
            final customIcon = BitmapDescriptor.fromBytes(trade.active == 1 ? activeIcon : inactiveIcon);
            final markerId = MarkerId(trade.id.toString());
            final marker = Marker(
              markerId: markerId, 
              position: LatLng(double.parse(trade.latitude), double.parse(trade.longitude)), 
              icon: customIcon, 
              anchor: Offset(0.5, 1),
              infoWindow: info,
              onTap: () => this._showMarkerDialog(trade, context)
            );

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

  goToMyPosition() async {
    if (this.state.myLocation != null) {
      final CameraUpdate cameraUpdate = CameraUpdate.newLatLng(this.state.myLocation);
      await (await _mapController).animateCamera(cameraUpdate);
    }
  }

  goToPlace(Business trade, BuildContext context) async {
    add(GoToPlace(trade, context));
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLng(LatLng(double.parse(trade.latitude), double.parse(trade.longitude)));
    await (await _mapController).animateCamera(cameraUpdate);
  }

  void setMapController(GoogleMapController controller) {
    if (_completer.isCompleted) {
      _completer = Completer();
    }

    _completer.complete(controller);
  }

  void _showMarkerDialog(Business trade, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text(trade.name, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descripción', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(trade.description, style: TextStyle(fontSize: 13)),
                SizedBox(height: 8),
                Text('Distancia', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(trade.distance.toStringAsFixed(3) + ' km.', style: TextStyle(fontSize: 13)),
                SizedBox(height: 8),
                Text('Estado', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(trade.active == 1 ? 'Activo' : 'Inactivo', style: TextStyle(fontSize: 13)),
              ]
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCELAR', style: TextStyle(fontSize: 14.0)),
                onPressed: () => Navigator.pop(context)
              ),
              FlatButton(
                child: Text('DETALLE', style: TextStyle(fontSize: 14.0)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessDetailPage(business: trade)))
              )
            ]
          )
        );
      }
    );
  }

  static AppointmentBloc of(BuildContext context) {
    return BlocProvider.of<AppointmentBloc>(context);
  }
}