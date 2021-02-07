import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId('my_location'),
        position: LatLng(widget.latitude, widget.longitude),
      )
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text('${allTranslations.traslate('ubicacion')}: ' + widget.client.toUpperCase(), style: labelTitleForm)
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 19),
        markers: _markers
      )
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}