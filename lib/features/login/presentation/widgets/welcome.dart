import 'package:flutter/material.dart';
import 'package:service_now/utils/responsive.dart';

class Welcome extends StatelessWidget {
  final String title;

  const Welcome({ @required this.title });

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 20),
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: 100
                  )
                )
              ]
            )
          )
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.ip(2.5),
            fontWeight: FontWeight.bold,
            fontFamily: 'raleway'
          )
        ),
        SizedBox(height: 30)
      ]
    );
  }
}