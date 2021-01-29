import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/appointment/domain/usecases/get_comments_by_business.dart';
import 'package:service_now/features/appointment/domain/usecases/get_galleries_by_business.dart';
import 'package:service_now/features/appointment/domain/usecases/request_business_by_user.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:service_now/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/appointment/presentation/pages/business_detail_page.dart';
import 'package:service_now/features/appointment/presentation/widgets/custom_dialog.dart';
// import 'package:service_now/features/appointment/presentation/pages/business_detail_page.dart';
// import 'package:service_now/features/appointment/presentation/widgets/custom_dialog.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/utils/extras_image.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _subscription;
  final GetBusinessByCategory getBusinessByCategory;
  final GetGalleriesByBusiness getGalleriesByBusiness;
  final GetCommentsByBusiness getCommentsByBusiness;
  final RequestBusinessByUser requestBusinessByUser;
  Completer<GoogleMapController> _completer = Completer();

  Future<GoogleMapController> get _mapController async {
    return await _completer.future;
  }

  AppointmentBloc({
    @required GetBusinessByCategory business,
    @required GetGalleriesByBusiness galleries,
    @required GetCommentsByBusiness comments,
    @required RequestBusinessByUser requestBusiness
  }) : assert(business != null, galleries != null),
       getBusinessByCategory = business,
       getGalleriesByBusiness = galleries,
       getCommentsByBusiness = comments,
       requestBusinessByUser = requestBusiness {
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
      this.state.copyWith(status: BusinessStatus.loadingGallery, services: []);
      final failureOrGalleries = await getGalleriesByBusiness(GetGalleriesParams(businessId: event.businessId));
      yield* _eitherLoadedGalleriesOrErrorState(failureOrGalleries);
    } else if (event is GetCommentsForUser) {
      final failureOrComments = await getCommentsByBusiness(GetCommentsParams(businessId: event.businessId));
      yield* _eitherLoadedCommentsOrErrorState(failureOrComments);
    } else if (event is GoToPlace) {
      final history = Map<String, Business>.from(this.state.history);

      final polylines = Map<PolylineId, Polyline>.from(this.state.polylines);
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id, 
        color: Colors.red, 
        points: event.polylineCoordinates,
        width: 3
      );

      polylines[id] = polyline;

      final Uint8List bytes = await placeToMarker(event.trade.name, event.duration, event.distance);
      BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(bytes);

      final MarkerId markerId = MarkerId('place');

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(event.trade.latitude), double.parse(event.trade.longitude)),
        icon: customIcon,
        anchor: Offset(0.48, 0.0),
        onTap: () => this._showMarkerDialog(event.trade, event.distance, event.context)
      );

      final markers = Map<MarkerId, Marker>.from(this.state.markers);
      markers[markerId] = marker;

      if (history[event.trade.id.toString()] == null) {
        history[event.trade.id.toString()] = event.trade;
        yield this.state.copyWith(status: BusinessStatus.ready, history: history, markers: markers, trade: event.trade, polylines: polylines);
      } else {
        yield this.state.copyWith(status: BusinessStatus.ready, markers: markers, trade: event.trade, polylines: polylines);
      }
    } else if (event is GetRequestServicesForUser) {
      yield this.state.copyWith(status: BusinessStatus.readyServices, services: _getServices(event.services));
    } else if (event is OnSelectedServiceEvent) {
      yield* this._mapOnSelectedService(event);
    } else if (event is RequestBusinessForUser) {
      final failureOrRequest = await requestBusinessByUser(Params(businessId: event.businessId));
      yield* _eitherRequestBusinessOrErrorState(failureOrRequest);
      Navigator.pushNamedAndRemoveUntil(event.context, HomePage.routeName, (Route<dynamic> route) => false);
    } else if (event is DrawPolyline) {
      final markers = Map<MarkerId, Marker>.from(this.state.markers);
      final List<Business> business = List<Business>.from(this.state.business);

      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id, 
        color: Colors.red, 
        points: event.polylineCoordinates,
        width: 3
      );

      final polylines = Map<PolylineId, Polyline>.from(this.state.polylines);
      polylines[id] = polyline;

      final Uint8List bytes = await placeToMarker(event.business.name, event.duration, event.distance);
      BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(bytes);

      final MarkerId markerId = MarkerId('place');

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(event.business.latitude), double.parse(event.business.longitude)),
        icon: customIcon,
        anchor: Offset(0.48, 0.0),
        onTap: () => this._showMarkerDialog(event.business, event.distance, event.context)
      );

      markers[markerId] = marker;

      yield this.state.copyWith(status: BusinessStatus.ready, business: business, markers: markers, polylines: polylines);
    }
  }

  List<Service> _getServices(Map<String, dynamic> json) {
    List<Service> services = List();
    for (var service in json['services']) {
      services.add(
        Service(
          id: service['business_service_id'],
          name: service['name'],
          price: service['price'],
          photos: [],
          discount: service['discount'],
          discountAmount: service['discount_ammount'],
          finalPrice: service['total'],
          selected: 0
        )
      );
    }

    return services;
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
              // onTap: () => this._showMarkerDialog(trade, context)
            );

            markers[markerId] = marker;
          }
        }

        return this.state.copyWith(status: BusinessStatus.ready, business: business, markers: markers);
      }
    );
  }

  Stream<AppointmentState> _eitherLoadedGalleriesOrErrorState(
    Either<Failure, List<Service>> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: BusinessStatus.error, services: []);
      },
      (galleries) {
        return this.state.copyWith(status: BusinessStatus.readyGallery, services: galleries);
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
      final CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(this.state.myLocation, 15);
      await (await _mapController).animateCamera(cameraUpdate);
    }
  }

  goToPlace(Business trade, List<LatLng> polylineCoordinates, String distance, String duration, double zoom, BuildContext context) async {
    add(GoToPlace(trade, polylineCoordinates, distance, duration, context));
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng(double.parse(trade.latitude), double.parse(trade.longitude)), zoom);
    await (await _mapController).animateCamera(cameraUpdate);
  }

  goToDirection(double latitude, double longitude, double latitudeDestino, double longitudeDestino, double zoom, List<LatLng> polylineCoordinates, Business business, String distance, String duration, BuildContext context) async {
    add(DrawPolyline(polylineCoordinates, business, distance, duration, context));
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng((latitude + latitudeDestino) / 2, (longitude + longitudeDestino) / 2), zoom);
    await (await _mapController).animateCamera(cameraUpdate);
  }

  void setMapController(GoogleMapController controller) {
    if (_completer.isCompleted) {
      _completer = Completer();
    }

    _completer.complete(controller);
  }

  Stream<AppointmentState> _mapOnSelectedService(OnSelectedServiceEvent event) async* {
    final int id = event.id;
    final List<Service> tmp = List<Service>.from(this.state.services);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onSelected();
      yield this.state.copyWith(status: BusinessStatus.readyServices, services: tmp);
    }
  }

  Stream<AppointmentState> _eitherRequestBusinessOrErrorState(
    Either<Failure, RequestBusinessResponse> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(selectBusinessStatus: SelectBusinessStatus.error);
      },
      (response) {
        return this.state.copyWith(selectBusinessStatus: SelectBusinessStatus.ready);
      }
    );
  }

  void _showMarkerDialog(Business trade, String distance, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: trade.name,
          description: trade.description,
          rating: trade.rating,
          distance: distance,
          buttonText: 'Detalle',
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessDetailPage(business: trade, distance: distance)));
          }
        );
      }
    );
  }

  static AppointmentBloc of(BuildContext context) {
    return BlocProvider.of<AppointmentBloc>(context);
  }
}