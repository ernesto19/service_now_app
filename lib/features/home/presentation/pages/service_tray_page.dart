import 'package:flutter/material.dart';
import 'package:service_now/blocs/client_bloc.dart';
import 'package:service_now/blocs/appointment_bloc.dart' as AppointmentBloc;
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_view_payment.dart';

class ServiceTrayPage extends StatefulWidget {
  static final routeName = 'service_tray_page';

  @override
  _ServiceTrayPageState createState() => _ServiceTrayPageState();
}

class _ServiceTrayPageState extends State<ServiceTrayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    bloc.obtenerBandejaServicios();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: bloc.allServicios,
              builder: (context, AsyncSnapshot<ServiciosPendientesResponse> snapshot) {
                if (snapshot.hasData) {
                  ServiciosPendientesResponse response = snapshot.data;

                  return response.data.length > 0 
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('services_tray_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildServiciosPendientes(response.data)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('services_tray_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                              SizedBox(height: 10),
                              Text(allTranslations.traslate('no_hay_informacion'))
                            ],
                          )
                        ),
                      )
                    ]
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return CustomScrollView(
                  slivers: [
                    Header(
                      title: allTranslations.traslate('services_tray_title'),
                      titleSize: 22,
                      onTap: () => Navigator.pop(context)
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: CircularProgressIndicator()
                        ),
                      )
                    )
                  ]
                );
              }
            )
          )
        ]
      )
    );
  }

  Widget _buildServiciosPendientes(List<ServicioPendiente> servicios) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          ServicioPendiente servicio = servicios[index];

          String estado;
          Color colorEstado;

          if (servicio.status == 0) {
            estado = allTranslations.traslate('estado_pendiente');
            colorEstado = Colors.green;
          } else if (servicio.status == 1) {
            estado = allTranslations.traslate('estado_iniciado');
            colorEstado = Colors.orange;
          } else {
            estado = allTranslations.traslate('estado_terminado');
            colorEstado = Colors.blue;
          }

          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: servicio.status == 2 ? 5 : 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(servicio.businessName.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                          ),
                          servicio.status == 2 ? PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == '1') {
                                List<Service> services = [];
                                servicio.servicesId.forEach((element) {
                                  // ignore: missing_required_param
                                  services.add(Service(id: element));
                                });
                                
                                AppointmentBloc.bloc.finalizarSolicitud(services, servicio.professionalId);
                                AppointmentBloc.bloc.finalizarServicioResponse.listen((response) {
                                  if (response.error == 0) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: response.url, professionalUserId: servicio.professionalId)));
                                  } else {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    this._showDialog(allTranslations.traslate('registro_fallido'), response.message);
                                  }
                                });
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: '1',
                                child: Row(
                                  children: [
                                    Text(allTranslations.traslate('solicitar_servicio'))
                                  ]
                                )
                              )
                            ]
                          ) : Container()
                        ]
                      ),
                      SizedBox(height: servicio.status == 2 ? 0 : 10),
                      Container(
                        child: Text(estado, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: colorEstado,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        )
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('${allTranslations.traslate('profesional_label')}: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                          ),
                          Expanded(
                            flex: 2,
                            child: Text((servicio.professionalName + ' ' + servicio.professionalLastName).toUpperCase(), style: TextStyle(fontSize: 13))
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('${allTranslations.traslate('servicios')}: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(servicio.servicesName, style: TextStyle(fontSize: 13))
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('${allTranslations.traslate('total')}: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('\$' + servicio.total + ' USD', style: TextStyle(fontSize: 13))
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      servicio.status == 0 ? Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.call, color: Colors.white, size: 20),
                                    SizedBox(width: 5),
                                    Text(allTranslations.traslate('llamar'), style: TextStyle(fontSize: 14, color: Colors.white))
                                  ]
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                color: Colors.green,
                                onPressed: servicio.progessionalPhone.isEmpty ? null : () => launch('tel://${servicio.progessionalPhone}')
                              ),
                            )
                          ]
                        ),
                      ) : Container()
                    ]
                  )
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(2, 2)
                  )
                ]
              )
            )
          );
        },
        childCount: servicios.length
      )
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
}