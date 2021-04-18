import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/libs/polylines/polylines_points.dart';
import 'package:service_now/utils/strings.dart';
import 'custom_search.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({ @required CameraPosition initialPosition }) : _initialPosition = initialPosition;

  final CameraPosition _initialPosition;

  @override
  _CustomGoogleMapState createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  double _originLatitude = -12.150931075847044, _originLongitude = -76.96052234619856;
  double _destLatitude = -12.156865846418716, _destLongitude = -76.95942968130112;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = googleMapsKey;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    _getPolyline();
  }

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
                initialCameraPosition: widget._initialPosition,
                zoomControlsEnabled: false,
                compassEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: state.markers.values.toSet(),
                // polylines: _polyline,
                polylines: Set<Polyline>.of(polylines.values),
                onTap: (location) {
                  print('$location');
                },
                onMapCreated: (GoogleMapController controller) {
                  bloc.setMapController(controller);
                }
              ),
              Positioned(
                bottom: 180,
                right: 15,
                child: FloatingActionButton(
                  child: Icon(Icons.gps_fixed, color: Colors.black),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    bloc.goToMyPosition();
                  }
                )
              ),
              Container(
                child: CustomSearch()
              )
            ]
          )
        );
      }
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id, 
      color: Colors.red, 
      points: polylineCoordinates,
      width: 5
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      print('======== ${result.distance.text} ========');
      print('======== ${result.duration.text} ========');
    }
    _addPolyLine();
  }
}