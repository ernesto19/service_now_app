import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({ @required CameraPosition initialPosition }) : _initialPosition = initialPosition;

  final CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState> (
      builder: (context, state) {
        // ignore: close_sinks
        final bloc = AppointmentBloc.of(context);

        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialPosition,
                zoomControlsEnabled: false,
                compassEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: state.markers.values.toSet(),
                onTap: (location) {
                  print('$location');
                },
                onMapCreated: (GoogleMapController controller) {
                  bloc.setMapController(controller);
                }
              ),
              Positioned(
                bottom: 130,
                right: 15,
                child: FloatingActionButton(
                  child: Icon(Icons.gps_fixed, color: Colors.black),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    bloc.goToMyPosition();
                  }
                )
              )
            ]
          )
        );
      }
    );
  }
}