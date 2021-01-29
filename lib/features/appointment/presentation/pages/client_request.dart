import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientRequest extends StatefulWidget {
  final String notification;

  const ClientRequest({ @required this.notification });

  @override
  _ClientRequestState createState() => _ClientRequestState();
}

class _ClientRequestState extends State<ClientRequest> {
  Map<String, dynamic> message;
  List<Service> services = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    message = json.decode(widget.notification);
    services = _getServices(message);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(allTranslations.traslate('solicitud'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: BlocProvider(
        create: (_) => sl<AppointmentBloc>(),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                            child: Text(allTranslations.traslate('seleccione_los_servicios_solicitar')),
                          ),
                        ),
                        services.length > 0 ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Service service = services[index];

                              return CheckboxListTile(
                                title: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(service.name, style: TextStyle(fontSize: 13)),
                                        Row(
                                          children: [
                                            service.discount.isEmpty ? Text('\$${service.price} USD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)) : Text('\$${service.price} USD', style: TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough)),
                                            SizedBox(width: 5),
                                            service.discount.isEmpty ? Container() : Container(
                                              child: Row(
                                                children: [
                                                  Text('\$${service.finalPrice} USD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5),
                                                  Container(
                                                    color: Colors.green,
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                    child: Text('-' + service.discount, style: TextStyle(fontSize: 10, color: Colors.white)),
                                                  )
                                                ]
                                              )
                                            )
                                          ]
                                        )
                                      ]
                                    )
                                  ],
                                ),
                                value: service.selected == 1,
                                activeColor: secondaryDarkColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    service.selected = service.selected == 1 ? 0 : 1;
                                  });
                                }
                              );
                            },
                            childCount: services.length
                          )
                        ) : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              padding: EdgeInsets.only(top: 150),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                                    SizedBox(height: 10),
                                    Text(allTranslations.traslate('no_hay_informacion'))
                                  ],
                                )
                              ),
                            ),
                            childCount: 1
                          )
                        )
                      ]
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: RoundedButton( 
                    label: allTranslations.traslate('confirm_request_button_text'),
                    backgroundColor: secondaryDarkColor,
                    width: double.infinity,
                    onPressed: () {
                      this._showProgressDialog();
                      bloc.finalizarSolicitud(services, int.parse(message['professional_user_id'].toString()));
                      bloc.finalizarServicioResponse.listen((response) {
                        if (response.error == 0) {
                          Navigator.pop(context);
                          _openWeb(response.url);
                        } else {
                          Navigator.pop(_scaffoldKey.currentContext);
                          this._showDialog(allTranslations.traslate('registro_fallido'), response.message);
                        }
                      });
                    }
                  )
                )
              ],
            );
          }
        )
      )
    );
  }

  void _showProgressDialog() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(allTranslations.traslate('registering_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.0),),
          actions: <Widget>[
            FlatButton(
              child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(_scaffoldKey.currentContext)
            )
          ],
        );
      }
    );
  }

  _openWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Service> _getServices(Map<String, dynamic> json) {
    List<Service> services = List();
    for (var service in json['services']) {
      services.add(
        Service(
          id: service['business_service_id'],
          name: service['name'],
          price: service['price'],
          photos: [],
          discount: service['discount'] ?? '',
          discountAmount: service['discount_ammount'] != null ? service['discount_ammount'].toString() : '',
          finalPrice: service['total'] != null ? service['total'].toString() : '',
          selected: 0
        )
      );
    }

    return services;
  }
}