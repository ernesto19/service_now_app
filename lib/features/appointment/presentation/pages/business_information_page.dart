import 'package:flutter/material.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/colors.dart';

import 'professionals_business_list_page.dart';

class BusinessInformationPage extends StatefulWidget {
  final Business business;

  const BusinessInformationPage({ @required this.business });

  @override
  _BusinessInformationPageState createState() => _BusinessInformationPageState();
}

class _BusinessInformationPageState extends State<BusinessInformationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Solicitar colaboración',
        currentButton: FloatingActionButton(
          heroTag: "colaboracion",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.work),
          onPressed: () {
            this._showProgressDialog();
            bloc.solicitarColaboracion(widget.business.id);
            bloc.solicitudColaboracionResponse.listen((response) {
              if (response.error == 0) {
                Navigator.pop(_scaffoldKey.currentContext);
                  this._showDialog('Envio exitoso', 'Su solicitud ha sido enviada exitosamente');
                } else {
                  Navigator.pop(_scaffoldKey.currentContext);
                  this._showDialog('Envio fallido', response.message);
                }
            });
          }
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Solicitar servicio',
        currentButton: FloatingActionButton(
          heroTag: "servicio",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.send),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessListPage(business: widget.business)))
        )
      )
    );

    return BlocProvider(
      create: (_) => sl<AppointmentBloc>(),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = AppointmentBloc.of(context);

          return Scaffold(
            key: _scaffoldKey,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(widget.business.name, style: TextStyle(fontSize: 19))
                            )
                          ]
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.business.rating),
                            SizedBox(width: 10),
                            RatingBar(
                              initialRating: double.parse(widget.business.rating),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: null
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('${widget.business.distance.toStringAsFixed(2)} km'),
                        SizedBox(height: 20),
                        Text(
                          widget.business.description
                        )
                      ]
                    )
                  )
                ),
                BlocBuilder<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    bloc.add(GetCommentsForUser(widget.business.id));

                    if (state.status == BusinessStatus.readyComments) {
                      List<Comment> comments = state.comments;

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Comment comment = comments[index];

                            return _buildComment(comment);
                          },
                          childCount: comments.length
                        ),
                      );
                    }

                    return SliverFillRemaining(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator()
                        ),
                      )
                    );
                  }
                )
              ]
            ),
            floatingActionButton: UserPreferences.instance.profileId == 0 ? FloatingActionButton(
              child: Icon(Icons.send),
              backgroundColor: secondaryDarkColor,
              onPressed: () {
                // bloc.add(RequestBusinessForUser(business.id, context));
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessListPage(business: widget.business)));
              }
            ) : UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              parentButtonBackground: secondaryDarkColor,
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.menu),
              childButtons: childButtons
            )
          );
        }
      )
    );
  }

  Widget _buildComment(Comment comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar(
                  initialRating: double.parse(comment.rating),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber
                  ),
                  ignoreGestures: true,
                  onRatingUpdate: null
                ),
                Text(
                  comment.comment,
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
        ],
      ),
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
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(_scaffoldKey.currentContext)
            )
          ],
        );
      }
    );
  }
}