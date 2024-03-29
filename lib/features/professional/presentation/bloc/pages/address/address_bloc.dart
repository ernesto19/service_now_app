import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:service_now/models/place.dart';
import 'package:service_now/utils/extras_image.dart';
import 'address_events.dart';
import 'address_state.dart';
import 'package:geolocator/geolocator.dart';

class AddressBloc extends Bloc<AddressEvents, AddressState> {
  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Completer<GoogleMapController> _completer = Completer();
  StreamSubscription<Position> _subscription;

  Future<GoogleMapController> get _mapController async {
    return await _completer.future;
  }

  AddressBloc() {
    this._init();
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    super.close();
  }

  _init() async {
    _subscription = _geolocator.getPositionStream(_locationOptions).listen(
      (Position position) async {
        if (position != null) {
          final newPosition = LatLng(position.latitude, position.longitude);
          add(OnMyLocationUpdate(newPosition));
        }
      }
    );
  }

  goToMyPosition() async {
    if (this.state.myLocation != null) {
      final CameraUpdate cameraUpdate = CameraUpdate.newLatLng(this.state.myLocation);
      await (await _mapController).animateCamera(cameraUpdate);
    }
  }

  goToPlace(Place place) async {
    add(GoToPlace(place));
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLng(place.position);
    await (await _mapController).animateCamera(cameraUpdate);
  }

  void setMapController(GoogleMapController controller) {
    if (_completer.isCompleted) {
      _completer = Completer();
    }

    _completer.complete(controller);
  }

  @override
  AddressState get initialState => AddressState.initialState;

  @override
  Stream<AddressState> mapEventToState(AddressEvents event) async* {
    if (event is OnMyLocationUpdate) {
      yield this.state.copyWith(loading: false, myLocation: event.location);
    } else if (event is GoToPlace) {
      final history = Map<String, Place>.from(this.state.history);
      final MarkerId markerId = MarkerId('place');

      final Uint8List bytes = await loadAsset('assets/icons/marker_active.png', width: 130, height: 130);
      final customIcon = BitmapDescriptor.fromBytes(bytes);

      final Marker marker = Marker(markerId: markerId, position: event.place.position, icon: customIcon, anchor: Offset(0.5, 1));
      final markers = Map<MarkerId, Marker>.from(this.state.markers);
      markers[markerId] = marker;

      if (history[event.place.id] == null) {
        history[event.place.id] = event.place;
        yield this.state.copyWith(history: history, markers: markers, place: event.place);
      } else {
        yield this.state.copyWith(markers: markers, place: event.place);
      }
    }
  }
}