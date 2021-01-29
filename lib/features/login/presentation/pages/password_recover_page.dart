import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import 'password_recover_change_page.dart';

class PasswordRecoverPage extends StatefulWidget {
  static final routeName = 'password_recover_page';

  @override
  _PasswordRecoverPageState createState() => _PasswordRecoverPageState();
}

class _PasswordRecoverPageState extends State<PasswordRecoverPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(allTranslations.traslate('recover_password'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            InputText(
              controller: _emailController,
              iconPath: 'assets/icons/mail.svg', 
              placeholder: allTranslations.traslate('email'),
              obscureText: false
            ),
            SizedBox(height: 30),
            RoundedButton(
              label: allTranslations.traslate('recuperar_boton'),
              width: 200,
              onPressed: () {
                this._showProgressDialog();
                String email = _emailController.text;
                bloc.solicitudRecuperarContrasena(email);
                bloc.solicitudRecuperarResponse.listen((response) {
                  if (response.error == 0) {
                    Navigator.pop(_scaffoldKey.currentContext);
                    this._showDialog(allTranslations.traslate('registro_exitoso'), 'La solicitud ha sido registrada exitosamente. Se ha enviado un correo con instrucciones a $email');
                  } else {
                    this._showDialog(allTranslations.traslate('registro_fallido'), response.message);
                  }
                });
              }
            )
          ]
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
                  child: Text(allTranslations.traslate('registering_message'), style: TextStyle(fontSize: 15.0)),
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
              onPressed: () => Navigator.pushNamed(_scaffoldKey.currentContext, PasswordRecoverChangePage.routeName)
            )
          ],
        );
      }
    );
  }
}