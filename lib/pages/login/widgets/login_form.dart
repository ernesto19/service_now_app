import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/libs/auth.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/pages/home/home_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/circle_button.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return SafeArea(
      top: false,
      child: Container(
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InputText(
              controller: _emailController,
              iconPath: 'assets/icons/mail.svg', 
              placeholder: allTranslations.traslate('email'),
              obscureText: false
            ),
            SizedBox(height: responsive.ip(2)),
            InputText(
              controller: _passwordController,
              iconPath: 'assets/icons/key.svg', 
              placeholder: allTranslations.traslate('password'),
              obscureText: true
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  allTranslations.traslate('recover_password'),
                  style: TextStyle(
                    fontFamily: 'sans'
                  )
                ), 
                onPressed: () { }
              )
            ),
            SizedBox(height: responsive.ip(2)),
            RoundedButton(
              label: allTranslations.traslate('log_in'),
              onPressed: () {
                bloc.login(_emailController.text, _passwordController.text).then((response) {
                  if (response.error == 0) {
                    User user = response.data;
                    UserPreferences.instance.userId   = user.id;
                    UserPreferences.instance.email    = user.email;
                    UserPreferences.instance.firstName = user.firstName;
                    UserPreferences.instance.lastName = user.lastName;
                    UserPreferences.instance.token    = user.token;

                    Navigator.pushNamed(context, HomePage.routeName, arguments: user);
                  }
                });
              }
            ),
            SizedBox(height: responsive.ip(3)),
            Text(allTranslations.traslate('or_continue')),
            SizedBox(height: responsive.ip(1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleButton(
                  iconPath: 'assets/icons/facebook.svg',
                  backgroundColor: Color(0xff448AFF),
                  size: 55,
                  onPressed: () async {
                    User user = await Auth.instance.facebook();
                    // Navigator.pushNamed(context, HomePage.routeName, arguments: user);
                  }
                ),
                SizedBox(width: 20),
                CircleButton(
                  iconPath: 'assets/icons/google.svg',
                  backgroundColor: Color(0xffFF1744),
                  size: 55,
                  onPressed: () async {
                    User user = await Auth.instance.google();
                    // Navigator.pushNamed(context, HomePage.routeName, arguments: user);
                  }
                )
              ]
            ),
            SizedBox(height: responsive.ip(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(allTranslations.traslate('not_have_account')),
                CupertinoButton(
                  child: Text(
                    allTranslations.traslate('create_account'),
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