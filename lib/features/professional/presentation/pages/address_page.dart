import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/professional/presentation/widgets/custom_app_bar.dart';
import 'package:service_now/models/place.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

import '../bloc/pages/address/bloc.dart';

class AddressPage extends StatefulWidget {
  static const routeName = 'address-page';

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final AddressBloc _bloc = AddressBloc();
  Place _place;

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
        body: _buildBody(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          child: RoundedButton(
            onPressed: () {
              Navigator.pop(context, _place);
            }, 
            label: allTranslations.traslate('confirm_address_button_text'),
            backgroundColor: secondaryDarkColor,
            width: double.infinity
          )
        )
      )
    );
  }

  Widget _buildBody() {
    return Container(
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
            _place = state.place;
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
              ),
              Container(
                child: CustomSearch()
              )
            ],
          );
        }
      )
    );
  }
}

class CustomSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 40),
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CustomAppBar()
            )
          ]
        )
      )
    );
  }
}