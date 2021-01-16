import 'package:flutter/material.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'professional_detail_page.dart';

class ProfessionalBusinessListPage extends StatefulWidget {
  final Business business;

  const ProfessionalBusinessListPage({ @required this.business });

  @override
  _ProfessionalBusinessListPageState createState() => _ProfessionalBusinessListPageState();
}

class _ProfessionalBusinessListPageState extends State<ProfessionalBusinessListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    bloc.obtenerProfesionalesPorNegocio(widget.business.id);
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
              stream: bloc.profesionales,
              builder: (context, AsyncSnapshot<ProfessionalResponse> snapshot) {
                if (snapshot.hasData) {
                  ProfessionalResponse response = snapshot.data;

                  return response.data.length > 0 
                  ? CustomScrollView(
                    slivers: [
                      Header(
                        title: widget.business.name,
                        subtitle: allTranslations.traslate('professionals_title').toUpperCase(),
                        titleSize: 22,
                        onTap: () => Navigator.pop(context)
                      ),
                      _buildProfesionales(response.data)
                    ],
                  ) 
                  : CustomScrollView(
                    slivers: [
                      Header(
                        title: widget.business.name,
                        subtitle: allTranslations.traslate('professionals_title').toUpperCase(),
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
                      title: widget.business.name,
                      subtitle: allTranslations.traslate('professionals_title').toUpperCase(),
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

  Widget _buildProfesionales(List<ProfessionalNegocio> profesionales) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          ProfessionalNegocio profesional = profesionales[index];
          String status = profesional.status.toUpperCase();

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
                            child: Text(profesional.firstName + ' ' + profesional.lastName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                          )
                        ]
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Text(status, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: status == allTranslations.traslate('activo') ? Colors.green : status == allTranslations.traslate('inactivo') ? Colors.red : Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        )
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('${allTranslations.traslate('c_electronico')}: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(profesional.email, style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('${allTranslations.traslate('celular')}: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(profesional.phone.isEmpty ? '-' : profesional.phone, style: TextStyle(fontSize: 13)),
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
                                  Icon(Icons.send, color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text(allTranslations.traslate('solicitar'), style: TextStyle(fontSize: 14, color: Colors.white))
                                ]
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              color: Colors.blueAccent,
                              onPressed: () {
                                this._showProgressDialog();
                                bloc.solicitarServicio(widget.business.id, profesional.userId);
                                bloc.solicitudServicioResponse.listen((response) {
                                  if (response.error == 0) {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    this._showDialog(allTranslations.traslate('envio_exitoso'), 'Su solicitud ha sido enviada exitosamente');
                                  } else {
                                    Navigator.pop(_scaffoldKey.currentContext);
                                    this._showDialog(allTranslations.traslate('envio_fallido'), response.message);
                                  }
                                });
                              }
                            ),
                          ),
                          SizedBox(width: 5),
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
                              onPressed: profesional.phone.isEmpty ? null : () => launch('tel://${profesional.phone}')
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
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalDetailPage(id: profesional.userId, name: profesional.firstName + ' ' + profesional.lastName)))
          );
        },
        childCount: profesionales.length
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
                  child: Text(allTranslations.traslate('sending_request_message'), style: TextStyle(fontSize: 15.0)),
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