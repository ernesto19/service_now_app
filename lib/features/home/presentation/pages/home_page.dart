import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/home/presentation/widgets/category_picker.dart';
import 'package:service_now/features/home/presentation/widgets/home_header.dart';
import 'package:service_now/features/home/presentation/widgets/menu.dart';
import 'package:service_now/injection_container.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/native/background_location.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/utils/pusher_client.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:service_now/widgets/expired_token_dialog.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();
  String _iniciales = '';
  final http.Client client = http.Client();
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  void dispose() async {
    super.dispose();
    await BackgroundLocation.instance.stop();
  }

  @override
  void initState() {
    _iniciales = UserPreferences.instance.lastName.toString().isEmpty ? UserPreferences.instance.firstName.substring(0, 2) : UserPreferences.instance.firstName.substring(0, 1) + UserPreferences.instance.lastName.substring(0, 1);
    
    if (UserPreferences.instance.serviceIsPending == 1) {
      BackgroundLocation.instance.start();

      BackgroundLocation.instance.stream.listen((LatLng position) async {
        if (UserPreferences.instance.currentLatitude != null) {
          if (UserPreferences.instance.currentLatitude != position.latitude || UserPreferences.instance.currentLongitude != position.longitude) {
            Geolocator geolocator = Geolocator();
            double distance = await geolocator.distanceBetween(UserPreferences.instance.currentLatitude, UserPreferences.instance.currentLongitude, position.latitude, position.longitude);

            if (distance > 10) {
              this.sendLocation(position);
            }
            
            UserPreferences.instance.currentLatitude = position.latitude;
            UserPreferences.instance.currentLongitude = position.longitude;
          }
        }
        
      });
    }

    getPendingServices();

    super.initState();
  }

  Future<void> sendLocation(LatLng at) async {
    final response = await client.post(
      'https://servicenow.konxulto.com/service_now/public/api/coordinates/send',
      headers: { 
        'Authorization'   : 'Bearer ${UserPreferences.instance.token}', 
        'Content-type'    : 'application/json',
        'Accept'          : 'application/json'
      },
      body: json.encode(
        {
          'lat': at.latitude.toString(),
          'long': at.longitude.toString(),
          'professional_id': UserPreferences.instance.serviceProfessionalId
        }
      )
    );

    if (response.statusCode == 200) {
      print('exito: ' + response.toString());
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _drawerKey,
      onTapClose: true,
      rightChild: Menu(),
      scaffold: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: buildBody(context)
        )
      )
    );
  }

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>(),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: CustomScrollView(
                slivers: [
                  HomeHeader(
                    name: _iniciales,
                    drawerKey: this._drawerKey
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      // ignore: close_sinks
                      final bloc = HomeBloc.of(context);
                      bloc.add(GetCategoriesForUser());

                      String text = '';

                      if (state.status == HomeStatus.ready) {
                        return CategoryPicker();
                      } else if (state.status == HomeStatus.checking) {
                        text = allTranslations.traslate('loading_message');
                      } else if (state.status == HomeStatus.selecting) {
                        return SettingsCategories();
                      } else {
                        text = 'Error';
                      }

                      return SliverFillRemaining(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            ),
                            Text(text)
                          ]
                        )
                      );
                    }
                  )
                ]
              )
            )
          ]
        )
      ),
    );
  }

  Future getPendingServices() async {
    final response = await client.post(
      'https://servicenow.konxulto.com/service_now/public/api/business_service/user_has_service',
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(
        {
          'user_id': UserPreferences.instance.userId
        }
      )
    );

    if (response.statusCode == 200) {
      final body = ResponsePendingService.fromJson(json.decode(response.body));

      if (body.error == 0) {
        if (body.data == 0) {
          UserPreferences.instance.serviceIsPending = 0;
        } else {
          UserPreferences.instance.serviceIsPending = 1;
        }
      } else {
        UserPreferences.instance.serviceIsPending = 0;
      }
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: ExpiredTokenDialog()
          );
        }
      );
    }
  }
}

class ResponsePendingService {
  int error;
  String message;
  int data;

  ResponsePendingService.fromJson(dynamic json) {
    error   = json['error'];
    message = json['message'];
    data    = json['data'];
  }
}