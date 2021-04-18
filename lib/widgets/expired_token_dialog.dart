import 'package:flutter/material.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/colors.dart';

class ExpiredTokenDialog extends StatelessWidget {
  const ExpiredTokenDialog();

  @override
  Widget build(BuildContext context) {    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 260.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 70,
                      height: 70,
                      child: Icon(Icons.info, color: Colors.redAccent, size: 55.0),
                      decoration: BoxDecoration(
                        color: backgroundDialogColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0, bottom: 5.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                              text: 'Su sesión ha expirado. \n\nVuelva a iniciar sesión para poder seguir navegando por la aplicación con normalidad.'
                            ),
                            textAlign: TextAlign.center
                          )
                        )
                      ]
                    )
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {
                        _clearData();
                        Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (Route<dynamic> route) => false);
                      },
                      child: Text('VOLVER A INICIAR SESIÓN', style: TextStyle(color: accentColor)),
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  void _clearData() {
    UserPreferences.instance.userId = 0;
    UserPreferences.instance.firstName = '';
    UserPreferences.instance.lastName = '';
    UserPreferences.instance.email = '';
    UserPreferences.instance.profileId = 0;
    UserPreferences.instance.rol = 0;
    UserPreferences.instance.serviceProfessionalId = 0;
    UserPreferences.instance.serviceIsPending = 0;
  }
}