import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/custom_app_bar.dart';
import 'blocs/pages/home/bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: this._bloc,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (_, state) {
              if (state.loading) {
                return Center(
                  child: CircularProgressIndicator()
                );
              }

              final CameraPosition initialPosition = CameraPosition(target: state.myLocation, zoom: 15);

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: initialPosition,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: state.markers.values.toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      this._bloc.setMapController(controller);
                    }
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: FloatingActionButton(
                      child: Icon(Icons.gps_fixed, color: Colors.black),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        this._bloc.goToMyPosition();
                      }
                    )
                  )
                ],
              );
            }
          )
        ),
      )
    );
  }
}