import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({ @required CameraPosition initialPosition }) : _initialPosition = initialPosition;

  final CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false
      )
    );
  }
}