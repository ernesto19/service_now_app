import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/libs/polylines/polylines_points.dart';
import 'package:service_now/libs/search_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/utils/all_translations.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyAQdtC9uL--5mlAEHC6W-niIeWKUCpE2Cc';

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<AppointmentBloc>(context);

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (_, state) {
        return Container(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black38, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Text(
                      allTranslations.traslate('buscar'),
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 17
                      )
                    )
                  ),
                  onTap: () async {
                    final List<Business> history = state.history.values.toList();
                    SearchPlaceDelegate delegate = SearchPlaceDelegate(
                      state.myLocation,
                      history
                    );
                    final Business business = await showSearch<Business>(
                      context: context,
                      delegate: delegate
                    );

                    if (business != null) {
                      polylineCoordinates = [];
                      _getPolyline(state.myLocation.latitude, state.myLocation.longitude, double.parse(business.latitude), double.parse(business.longitude), business, bloc, context);
                    }
                  }
                )
              )
            ]
          )
        );
      }
    );
  }

  _getPolyline(double origenLatitude, double origenLongitude, double latitude, double longitude, Business business, AppointmentBloc bloc, BuildContext context) async {
    double zoom = 14.5;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(origenLatitude, origenLongitude),
      PointLatLng(latitude, longitude),
      travelMode: TravelMode.driving
    );

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

      bloc.goToPlace(business, polylineCoordinates, result.distance.text, result.duration.text, zoom, context);
    }
  }
}

class SearchPlaceDelegate extends SearchDelegate<Business> {
  final LatLng at;
  final List<Business> history;
  final SearchAPI _api = SearchAPI.instance;

  SearchPlaceDelegate(this.at, this.history);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          this.query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back), 
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (this.query.trim().length > 3) {
      return FutureBuilder<List<Business>>(
        future: _api.searchBusiness(this.query, this.at),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final Business business = snapshot.data[index];
                return ListTile(
                  title: Text(business.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(business.address, style: TextStyle(fontSize: 12)),
                  onTap: () => this.close(context, business)
                );
              },
              itemCount: snapshot.data.length
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('ERROR!')
            );
          } 
          
          return Center(
            child: CircularProgressIndicator()
          );
        }
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Business> history = this.history;

    if (this.query.trim().length > 0) {
      final tmp = this.query.toLowerCase();
      history = history.where((element) {
        if (element.name.toLowerCase().contains(tmp)) {
          return true;
        } else if (element.address.toLowerCase().contains(tmp)) {
          return true;
        }

        return false;
      }).toList();
    }

    return ListView.builder(
      itemBuilder: (_, index) {
        final Business place = history[index];
        return ListTile(
          leading: Icon(Icons.history),
          onTap: () => this.close(context, place),
          title: Text(
            place.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(place.address),
        );
      },
      itemCount: history.length,
    );
  }
}