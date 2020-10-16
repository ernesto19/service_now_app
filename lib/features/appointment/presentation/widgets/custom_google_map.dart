import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({ @required CameraPosition initialPosition }) : _initialPosition = initialPosition;

  final CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState> (builder: (_, state) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          markers: state.markers.values.toSet(),
          onTap: (location) {
            print('$location');
          },
        )
      );
    });
  }
}