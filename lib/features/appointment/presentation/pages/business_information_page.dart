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
import 'package:simple_moment/simple_moment.dart';
import 'professionals_business_list_page.dart';

class BusinessInformationPage extends StatefulWidget {
  final Business business;
  final String distance;

  const BusinessInformationPage({ @required this.business, @required this.distance });

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
        labelText: allTranslations.traslate('solicitar_colaboracion'),
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
                  this._showDialog(allTranslations.traslate('envio_exitoso'), 'Su solicitud ha sido enviada exitosamente');
                } else {
                  Navigator.pop(_scaffoldKey.currentContext);
                  this._showDialog(allTranslations.traslate('envio_fallido'), response.message);
                }
            });
          }
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: allTranslations.traslate('solicitar_servicio'),
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
                            Text(double.parse(widget.business.rating).toString()),
                            SizedBox(width: 10),
                            RatingBar.builder(
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
                        Text(widget.distance),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(comment.firstName + ' ' + comment.lastName, style: TextStyle(fontSize: 12))
                    ),
                    Text(_buildMoment(comment.createdAt).replaceFirst(allTranslations.traslate('en'), allTranslations.traslate('hace')), style: TextStyle(fontSize: 11))
                  ],
                ),
                SizedBox(height: 5),
                RatingBar.builder(
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
                  '"' + comment.comment + '"',
                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildMoment(String date) {
    Moment.setLocaleGlobally(new LocaleEs());
    var updateDate = DateTime.parse(date);
    var moment = new Moment.now();
    String text = moment.from(updateDate);
    return '${text[0].toUpperCase()}${text.substring(1, text.length)}';
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