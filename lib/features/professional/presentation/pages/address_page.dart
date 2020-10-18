import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/professional/presentation/widgets/custom_app_bar.dart';

import '../bloc/pages/address/bloc.dart';

class AddressPage extends StatefulWidget {
  static const routeName = 'address-page';

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final AddressBloc _bloc = AddressBloc();
  String locationString = 'sin place';

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
        bottomNavigationBar: RaisedButton(
          child: Text('Confirmar dirección'),
          onPressed: () {
            Navigator.pop(context, locationString);
          }
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<AddressBloc, AddressState>(
            builder: (_, state) {
              if (state.loading) {
                return Center(
                  child: CircularProgressIndicator()
                );
              }

              final CameraPosition initialPosition = CameraPosition(target: state.myLocation, zoom: 15);

              if (state.place != null) {
                locationString = state.place.title + ', ' + state.place.vicinity;
              }

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