import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'home_page.dart';

class ChangePasswordPage extends StatefulWidget {
  static final routeName = 'change_password_page';

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscureTextCurrentPassword = true;
  bool _obscureTextPassword = true;
  bool _obscureTextPasswordConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(allTranslations.traslate('cambiar_contrasena'), style: labelTitleForm),
          backgroundColor: primaryColor
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            InputText(
              controller: _currentPasswordController,
              iconPath: 'assets/icons/key.svg',
              placeholder: allTranslations.traslate('contrasena_actual'),
              obscureText: _obscureTextCurrentPassword,
              suffix: _crearVisibilityCurrentPassword()
            ),
            SizedBox(height: 10),
            InputText(
              controller: _passwordController,
              iconPath: 'assets/icons/key.svg',
              placeholder: allTranslations.traslate('nueva_contrasena'),
              obscureText: _obscureTextPassword,
              suffix: _crearVisibilityPassword()
            ),
            SizedBox(height: 10),
            InputText(
              controller: _passwordConfirmController,
              iconPath: 'assets/icons/key.svg',
              placeholder: allTranslations.traslate('confirmar_nueva_contrasena'),
              obscureText: _obscureTextPasswordConfirm,
              suffix: _crearVisibilityPasswordConfirm()
            ),
            SizedBox(height: 30),
            RoundedButton(
              label: allTranslations.traslate('cambiar_contrasena'),
              width: 250,
              onPressed: () {
                this._showProgressDialog();
                String currentPassword = _currentPasswordController.text;
                String password = _passwordController.text;
                String passwordConfirm = _passwordConfirmController.text;
                bloc.cambiarContrasena(currentPassword, password, passwordConfirm);
                bloc.cambiarResponse.listen((response) {
                  if (response.error == 0) {
                    Navigator.pop(_scaffoldKey.currentContext);
                    this._showDialog(allTranslations.traslate('actualizacion_exitosa'), 'Su contraseña ha sido actualizada exitosamente.');
                  } else {
                    Navigator.pop(_scaffoldKey.currentContext);
                    this._showDialog(allTranslations.traslate('actualizacion_fallida'), response.message);
                  }
                });
              }
            )
          ]
        )
      )
    );
  }

  Widget _crearVisibilityCurrentPassword() {
    return IconButton(
      icon: _obscureTextCurrentPassword ? Icon(Icons.visibility_off, color: Color(0xffcccccc)) : Icon(Icons.visibility, color: Color(0xffcccccc)),
      onPressed: () {
        setState(() {
          _obscureTextCurrentPassword = !_obscureTextCurrentPassword;
        });
      },
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
                  child: Text(allTranslations.traslate('updating_message'), style: TextStyle(fontSize: 15.0)),
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
          title: Text(title,
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(_scaffoldKey.currentContext, HomePage.routeName, (route) => false)
            )
          ],
        );
      }
    );
  }
}