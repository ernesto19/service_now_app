import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/circle_button.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return SafeArea(
      top: false,
      child: Container(
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InputText(
              iconPath: 'assets/icons/mail.svg', 
              placeholder: 'Correo electrónico'
            ),
            SizedBox(height: responsive.ip(2)),
            InputText(
              iconPath: 'assets/icons/key.svg', 
              placeholder: 'Contraseña'
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    fontFamily: 'sans'
                  )
                ), 
                onPressed: () { }
              )
            ),
            SizedBox(height: responsive.ip(2)),
            RoundedButton(
              label: 'Iniciar sesión',
              onPressed: () => {}
              // onPressed: () => Navigator.pushReplacementNamed(context, MainPage.routeName)
            ),
            SizedBox(height: responsive.ip(3)),
            Text('o continúe con'),
            SizedBox(height: responsive.ip(1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleButton(
                  iconPath: 'assets/icons/facebook.svg',
                  backgroundColor: Color(0xff448AFF),
                  size: 55
                ),
                SizedBox(width: 20),
                CircleButton(
                  iconPath: 'assets/icons/google.svg',
                  backgroundColor: Color(0xffFF1744),
                  size: 55
                )
              ]
            ),
            SizedBox(height: responsive.ip(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('¿Aún no tiene una cuenta?'),
                CupertinoButton(
                  child: Text(
                    'Registrarme',
                    style: TextStyle(
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w600
                    ),
                  ), 
                  onPressed: () {}
                )
              ]
            )
          ]
        )
      ),
    );
  }
}