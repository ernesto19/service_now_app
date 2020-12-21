import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/professional/presentation/widgets/animation_fab.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:service_now/widgets/success_page.dart';

class ClientRating extends StatefulWidget {
  final String notification;

  const ClientRating({ @required this.notification });

  @override
  _ClientRatingState createState() => _ClientRatingState();
}

class _ClientRatingState extends State<ClientRating> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> message;
  int paymentId = 0;
  double rating = 1.0;
  final _commentController = TextEditingController();

  @override
  void initState() {
    message = json.decode(widget.notification);
    paymentId = message['payment_id'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Calificación', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(message['message']),
                          SizedBox(height: 20),
                          TextField(
                            controller: _commentController,
                            keyboardType: TextInputType.text,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: hintColor),
                              hintText: 'Escribe tu comentario',
                              counterText: ''
                            ),
                            style: TextStyle(fontSize: 15.0, color: Colors.black87),
                            maxLines: 5
                          ),
                          SizedBox(height: 40),
                          RatingBar(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 50,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber
                            ),
                            unratedColor: Colors.grey[300],
                            onRatingUpdate: (value) {
                              setState(() {
                                rating = value;
                              });
                            }
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Calificación: ', style: TextStyle(fontSize: 16)),
                              Text(rating.toString(), style: TextStyle(fontSize: 20))
                            ]
                          )
                        ]
                      )
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
                bloc.enviarCalificacion(paymentId, _commentController.text, rating);
                bloc.enviarCalificacionResponse.listen((response) {
                  if (response.error == 0) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(FadeRouteBuilder(page: SuccessPage(message: 'La calificación ha sido enviada exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
                  }
                });
              }, 
              label: 'Enviar calificación',
              backgroundColor: secondaryDarkColor,
              width: double.infinity
            )
          )
        ]
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
                  child: Text(allTranslations.traslate('sending_rating_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}