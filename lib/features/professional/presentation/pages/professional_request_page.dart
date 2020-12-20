import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalRequest extends StatefulWidget {
  final String notification;

  const ProfessionalRequest({ @required this.notification });

  @override
  _ProfessionalRequestState createState() => _ProfessionalRequestState();
}

class _ProfessionalRequestState extends State<ProfessionalRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> message = json.decode(widget.notification);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Solicitud', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: BlocProvider(
        create: (_) => sl<ProfessionalBloc>(),
        child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
          builder: (context, state) {
            // ignore: close_sinks
            final blocProf = ProfessionalBloc.of(context);
            blocProf.add(GetServicesForProfessional(int.parse(message['business_id'].toString())));

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
                            child: Text('Seleccione los servicios que puede brindar en estos momentos'),
                          ),
                        ),
                        state.status != ProfessionalStatus.readyServices ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            childCount: 1
                          )
                        ) : state.services.length > 0 ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ProfessionalService service = state.services[index];

                              return CheckboxListTile(
                                title: Text(service.name, style: TextStyle(fontSize: 13)),
                                value: service.selected == 1,
                                activeColor: secondaryDarkColor,
                                onChanged: (bool value) {
                                  blocProf.add(OnSelectedServiceEvent(service.id));
                                }
                              );
                            },
                            childCount: state.services.length
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
                                    Text('No hay registros para mostrar')
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
                    onPressed: () {
                      this._showProgressDialog();
                      bloc.responderSolicitudServicio(state.services.where((element) => element.selected == 1).toList(), int.parse(message['user_id'].toString()));
                      bloc.respuestaSolicitudResponse.listen((response) {
                        if (response.error == 0) {
                          Navigator.pop(_scaffoldKey.currentContext);
                          this._showDialog('Envio exitoso', 'Su respuesta ha sido enviada exitosamente');
                        } else {
                          Navigator.pop(_scaffoldKey.currentContext);
                          this._showDialog('Envio fallido', response.message);
                        }
                      });
                    }, 
                    label: allTranslations.traslate('confirm_request_button_text'),
                    backgroundColor: secondaryDarkColor,
                    width: double.infinity
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
                  child: Text(allTranslations.traslate('sending_response_message'), style: TextStyle(fontSize: 15.0)),
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
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(_scaffoldKey.currentContext)
            )
          ],
        );
      }
    );
  }
}