import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/hex_color.dart';

import 'client_map_page.dart';

class PendingServiceTrayPage extends StatefulWidget {
  static final routeName = 'pending_service_tray_page';

  @override
  _PendingServiceTrayPageState createState() => _PendingServiceTrayPageState();
}

class _PendingServiceTrayPageState extends State<PendingServiceTrayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    bloc.obtenerBandejaServiciosPendientes();
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
              stream: bloc.allServiciosPendientes,
              builder: (context, AsyncSnapshot<ServiciosPendientesResponse> snapshot) {
                if (snapshot.hasData) {
                  ServiciosPendientesResponse response = snapshot.data;

                  return response.data.length > 0 
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('pending_services_title'),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildServiciosPendientes(response.data)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: allTranslations.traslate('pending_services_title'),
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
                      title: allTranslations.traslate('pending_services_title'),
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

          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text((servicio.firstName + ' ' + servicio.lastName).toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                          )
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('${allTranslations.traslate('negocio')}: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(servicio.businessName, style: TextStyle(fontSize: 13))
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
                            flex: 3,
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
                            flex: 3,
                            child: Text('\$' + servicio.total + ' USD', style: TextStyle(fontSize: 13))
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('${allTranslations.traslate('ubicacion')}: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              child: Text('${allTranslations.traslate('ver_mapa')}', style: TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline)),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClientMapPage(latitude: double.parse(servicio.clientLatitude), longitude: double.parse(servicio.clientLongitude), client: servicio.firstName + ' ' + servicio.lastName)))
                            )
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow, color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text(allTranslations.traslate('iniciar_servicio'), style: TextStyle(fontSize: 12, color: Colors.white))
                                ]
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              color: servicio.status == 0 ? HexColor('#77D077') : HexColor('#E3E0E0'),
                              onPressed: servicio.status == 0 ? () {
                                this._showProgressDialog(allTranslations.traslate('iniciando_servicio'));
                                bloc.iniciarServicio(servicio.id);
                                bloc.iniciarServicioResponse.listen((response) {
                                  if (response.error == 0) {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    this._showDialog(allTranslations.traslate('inicio_exitoso'), allTranslations.traslate('servicio_iniciado_exitosamente'));
                                    bloc.obtenerBandejaServiciosPendientes();
                                  } else {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    this._showDialog(allTranslations.traslate('inicio_fallido'), response.message);
                                  }
                                });
                              } : () {}
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: RaisedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stop, color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text(allTranslations.traslate('terminar_servicio'), style: TextStyle(fontSize: 12, color: Colors.white))
                                ]
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              color: servicio.status == 1 ? HexColor('#BD7AD1') : HexColor('#E3E0E0'),
                              onPressed: servicio.status == 1 ? () {
                                this._showProgressDialog(allTranslations.traslate('finalizando_servicio'));
                                bloc.terminarServicio(servicio.id);
                                bloc.terminarServicioResponse.listen((response) {
                                  Navigator.pop(_scaffoldKey.currentContext);
                                  this._showDialog(allTranslations.traslate('finalizacion_exitosa'), allTranslations.traslate('servicio_finalizado_exitosamente'));
                                  bloc.obtenerBandejaServiciosPendientes();
                                });
                              } : () {}
                            ),
                          )
                        ]
                      ),
                      SizedBox(height: 5)
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

  void _showProgressDialog(String message) {
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
                  child: Text(message, style: TextStyle(fontSize: 15.0)),
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
}