import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

class BackgroundLocation {
  BackgroundLocation._internal();

  static BackgroundLocation _instance = BackgroundLocation._internal();
  static BackgroundLocation get instance => _instance;

  final _methodChannel = MethodChannel('app.service_now/background-location');

  Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10
  );

  StreamController<LatLng> _controller = StreamController.broadcast();

  StreamSubscription _androidSubs;

  bool _running = false;

  Stream<LatLng> get stream => _controller.stream;

  Future<void> start() async {
    if (_running) throw new Exception('background location running');

    if (Platform.isAndroid) {
      _androidSubs = _geolocator.getPositionStream().listen((Position position) {
        if (position != null) {
          _controller.sink.add(LatLng(position.latitude, position.longitude));
        }
      });
    }

    _methodChannel.invokeMethod('start');

    _running = true;
  }

  Future<void> stop() async {
    await _androidSubs?.cancel();
    await _methodChannel.invokeMethod('stop');
    _controller.close();
    _running = false;
  }
}