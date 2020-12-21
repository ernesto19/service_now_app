import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/features/appointment/presentation/widgets/custom_rating_bar.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/libs/polylines/polylines_points.dart';
import 'package:service_now/utils/colors.dart';
import '../widgets/custom_search.dart';
import 'business_detail_page.dart';

class SearchBusinessPage extends StatefulWidget {
  static final routeName = 'search_business_page';
  final Category category;

  SearchBusinessPage({Key key, this.category}) : super(key: key);

  @override
  _SearchBusinessPageState createState() => _SearchBusinessPageState();
}

class _SearchBusinessPageState extends State<SearchBusinessPage> {
  double _originLatitude = 0.0; 
  double _originLongitude = 0.0;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyAQdtC9uL--5mlAEHC6W-niIeWKUCpE2Cc';
  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor pinLocationIcon;

  BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentBloc>(),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state.status == BusinessStatus.loading) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else {
            // ignore: close_sinks
            final bloc = AppointmentBloc.of(context);
            bloc.add(GetBusinessForUser(widget.category.id, state.myLocation.latitude.toString(), state.myLocation.longitude.toString(), context));

            _originLatitude = state.myLocation.latitude;
            _originLongitude = state.myLocation.longitude;
          
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(target: state.myLocation, zoom: 14.5),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: state.markers.values.toSet(),
                          polylines: state.polylines.values.toSet(),
                          onTap: (location) {
                            print('$location');
                          },
                          onMapCreated: (GoogleMapController controller) {
                            bloc.setMapController(controller);
                          },
                        ),
                        Positioned(
                          bottom: state.business.length > 0 ? 180 : 15,
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
                  ),
                  BlocBuilder<AppointmentBloc, AppointmentState>(
                    builder: (_, state) {
                      if (state.status == BusinessStatus.ready) {
                        return _buildContainer(state.business, bloc);
                      } else {
                        return Container();
                      }
                    }
                  )
                ]
              )
            );
          }
        }
      )
    );
  }

  Widget _buildContainer(List<Business> businessList, AppointmentBloc bloc) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: businessList.length,
          itemBuilder: (context, index) {
            Business business = businessList[index];

            return Padding(
              padding: EdgeInsets.all(8),
              child: _buildBusinessCard(
                business.gallery.length > 0
                ? business.gallery[0].url
                // ? 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png'
                : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png',
                business,
                bloc
              )
            );
          }
        )
      )
    );
  }

  Widget _buildBusinessCard(String image, Business business, AppointmentBloc bloc) {
    return  GestureDetector(
      onTap: () {
        polylineCoordinates = [];
        _getPolyline(double.parse(business.latitude), double.parse(business.longitude), business, bloc);
      },
      child:Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.circular(24),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 210,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(image),
                    )
                  )
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: _buildBusinessDetail(business),
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  Widget _buildBusinessDetail(Business business) {
    String address = '';
    int index = business.address.indexOf('-');
    if (index > 0) {
      address = business.address.substring(0, index);
    } else {
      address = business.address;
    }

    return Container(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8, top: 5),
            child: Container(
              child: Text(business.name,
                style: TextStyle(
                  color: Color(0xff6200ee),
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center
              )
            ),
          ),
          SizedBox(height: 10),
          CustomRatingBar(business: business),
          SizedBox(height: 8),
          Text(address, style: TextStyle(fontSize: 17)),
          SizedBox(height: 8),
          Container(
            child: Text(
              business.active == 1 ? 'Activo' : 'Inactivo',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 19,
                fontWeight: FontWeight.bold
              )
            )
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.business, color: Colors.white, size: 20),
                            SizedBox(width: 5),
                            Text('Detalle', style: TextStyle(fontSize: 16, color: Colors.white))
                          ]
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        color: secondaryDarkColor,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessDetailPage(business: business, distance: '${business.distance.toStringAsFixed(2)} km')))
                      ),
                    )
                  ],
                )
              ]
            )
          )
        ]
      ),
    );
  }

  _getPolyline(double latitude, double longitude, Business business, AppointmentBloc bloc) async {
    double zoom = 14.5;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
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

      bloc.goToDirection(_originLatitude, _originLongitude, double.parse(business.latitude), double.parse(business.longitude), zoom, polylineCoordinates, business, result.distance.text, result.duration.text, context);
    }
  }
}