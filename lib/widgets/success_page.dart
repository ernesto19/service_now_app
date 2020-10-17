import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  final String assetImage;
  final Widget page;
  final int levelsNumber;
  final String pageName;

  const SuccessPage({this.message, this.assetImage, this.page, this.levelsNumber, @required this.pageName});

  @override
  Widget build(BuildContext context) {
    _goToSuccess(context);
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white
    ));

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Image.asset(
                  assetImage,
                  width: 180.0,
                  height: 180.0
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(message, style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center)
                )
              ],
            )
          ),
        )
      )
    );
  }

  Future<Null> _goToSuccess(BuildContext context) async {
    final duration = new Duration(seconds: 3);
    new Timer( duration, () {
      Navigator.of(context).pushNamedAndRemoveUntil(pageName, (Route<dynamic> route) => false);
    });

    return Future.delayed(duration);
  }
}