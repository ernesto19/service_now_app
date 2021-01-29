import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import 'login_page.dart';

class PasswordRecoverChangePage extends StatefulWidget {
  static final routeName = 'password_recover_change_page';

  @override
  _PasswordRecoverChangePageState createState() => _PasswordRecoverChangePageState();
}

class _PasswordRecoverChangePageState extends State<PasswordRecoverChangePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextPasswordConfirm = true;

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
              controller: _codeController,
              iconPath: 'assets/icons/information.svg', 
              placeholder: allTranslations.traslate('codigo'),
              obscureText: false
            ),
            SizedBox(height: 10),
            InputText(
              controller: _passwordController,
              iconPath: 'assets/icons/key.svg', 
              placeholder: allTranslations.traslate('password'),
              obscureText: _obscureTextPassword,
              suffix: _crearVisibilityPassword()
            ),
            SizedBox(height: 10),
            InputText(
              controller: _passwordConfirmController,
              iconPath: 'assets/icons/key.svg', 
              placeholder: allTranslations.traslate('confirm_password'),
              obscureText: _obscureTextPasswordConfirm,
              suffix: _crearVisibilityPasswordConfirm()
            ),
            SizedBox(height: 30),
            RoundedButton(
              label: allTranslations.traslate('recuperar_boton'),
              width: 200,
              onPressed: () {
                this._showProgressDialog();
                String code = _codeController.text;
                String password = _passwordController.text;
                String passwordConfirm = _passwordConfirmController.text;
                bloc.recuperarContrasena(code, password, passwordConfirm);
                bloc.recuperarResponse.listen((response) {
                  if (response.error == 0) {
                    this._showDialog(allTranslations.traslate('registro_exitoso'), 'Su contraseña ha sido reestablecida exitosamente.');
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

  Widget _crearVisibilityPassword() {
    return IconButton(
      icon: _obscureTextPassword ? Icon(Icons.visibility_off, color: Color(0xffcccccc)) : Icon(Icons.visibility, color: Color(0xffcccccc)),
      onPressed: () {
        setState(() {
          _obscureTextPassword = !_obscureTextPassword;
        });
      },
    );
  }

  Widget _crearVisibilityPasswordConfirm() {
    return IconButton(
      icon: _obscureTextPasswordConfirm ? Icon(Icons.visibility_off, color: Color(0xffcccccc)) : Icon(Icons.visibility, color: Color(0xffcccccc)),
      onPressed: () {
        setState(() {
          _obscureTextPasswordConfirm = !_obscureTextPasswordConfirm;
        });
      },
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
              onPressed: () => Navigator.pushNamedAndRemoveUntil(_scaffoldKey.currentContext, LoginPage.routeName, (route) => false)
            )
          ],
        );
      }
    );
  }
}