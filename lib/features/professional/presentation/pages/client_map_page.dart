import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/libs/polylines/polylines_points.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/extras_image.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:geolocator/geolocator.dart';

class ClientMapPage extends StatefulWidget {
  const ClientMapPage({ @required this.latitude, @required this.longitude, @required this.client });

  final double latitude;
  final double longitude;
  final String client;

  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polylines = Set();
  List<LatLng> polylineCoordinates = [];
  String googleAPiKey = 'AIzaSyB99NUlWv27VQoa8-a7fQytfwgV0-n2yhY';
  PolylinePoints polylinePoints = PolylinePoints();
  double zoom = 14.5;

  connect() {
    PusherOptions options = PusherOptions(
      host: 'servicenow.konxulto.com',
      port: 6001,
      encrypted: false,
    );
    FlutterPusher pusher = FlutterPusher('local', options, enableLogging: true);

    Echo echo = new Echo({
      'broadcaster': 'pusher',
      'key': 'local',
      'cluster': 'mt1',
      'forceTLS': false,
      'wsHost': 'servicenow.konxulto.com',
      'wsPort': 6001,
      'disableStatus': true,
      'client': pusher,
    });

    echo.channel('coordenadas.${UserPreferences.instance.userId}').listen('Coordinates', (e) {
      polylineCoordinates = [];
      _getPolyline(double.parse(e['lat']), double.parse(e['long']));
    });
  }

  @override
  Widget build(BuildContext context) {
    connect();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text('${allTranslations.traslate('ubicacion')}: ' + widget.client.toUpperCase(), style: labelTitleForm)
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: zoom),
        zoomControlsEnabled: true,
        compassEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        polylines: _polylines,
        onTap: (location) {
          print('$location');
        },
        onMapCreated: _onMapCreated
      )
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _getPolyline(double latitude, double longitude) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(UserPreferences.instance.currentLatitude, UserPreferences.instance.currentLongitude),
      PointLatLng(latitude, longitude),
      travelMode: TravelMode.driving
    );

    print(result.errorMessage);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      if (result.distance.value > 0 && result.distance.value < 3000) {
        zoom = 14.4;
      } else if (result.distance.value > 3001 && result.distance.value < 6000) {
        zoom = 13.9;
      } else if (result.distance.value > 6001 && result.distance.value < 9000) {
        zoom = 13.3;
      } else {
        zoom = 10;
      }

      final Uint8List bytes = await loadAsset('assets/icons/location_marker.png', width: 130, height: 130);
      final customIcon = BitmapDescriptor.fromBytes(bytes);

      _markers.add(
        Marker(
          markerId: MarkerId('client_market'),
          position: LatLng(latitude, longitude),
          icon: customIcon
        )
      );

      _polylines.add(
        Polyline(
          polylineId: PolylineId('linea'),
          color: Colors.red,
          points: polylineCoordinates,
          width: 3
        )
      );

      setState(() {});

      // bloc.goToDirection(_originLatitude, _originLongitude, double.parse(business.latitude), double.parse(business.longitude), zoom, polylineCoordinates, business, result.distance.text, result.duration.text, context);
    }
  }
}