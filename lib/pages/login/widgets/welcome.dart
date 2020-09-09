import 'package:flutter/material.dart';
import 'package:service_now/utils/responsive.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    
    return Column(
      children: <Widget>[
        // AspectRatio(
        //   aspectRatio: 16 / 11,
        //   child: LayoutBuilder(
        //     builder: (_, contraints) {
        //       return Container(
        //         child: Container(
        //           child: Stack(
        //             children: <Widget>[
        //               Center(
        //                 child: Image.asset(
        //                   'assets/images/logo.jpeg',
        //                   width: contraints.maxWidth * 0.35
        //                 )
        //               )
        //             ]
        //           )
        //         )
        //       );
        //     }
        //   )
        // ),
        Container(
          padding: EdgeInsets.only(top: 80, bottom: 30),
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    // width: contraints.maxWidth * 0.35
                    width: 110
                  )
                )
              ]
            )
          )
        ),
        Text(
          '¡Bienvenido!',
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