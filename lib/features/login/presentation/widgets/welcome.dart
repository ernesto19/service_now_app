import 'package:flutter/material.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 30),
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: 110
                  )
                )
              ]
            )
          )
        ),
        Text(
          allTranslations.traslate('welcome'),
          style: TextStyle(
            fontSize: responsive.ip(2.5),
            fontWeight: FontWeight.bold,
            fontFamily: 'raleway'
          )
        ),
        SizedBox(height: 40)
      ]
    );
  }
}