import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_now/utils/responsive.dart';

import 'widgets/login_form.dart';
import 'widgets/welcome.dart';

class LoginPage extends StatefulWidget {
  static final routeName = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.white,
          color: Color.fromRGBO(247, 247, 247, 1),
          child: SingleChildScrollView(
            child: Container(
              // height: responsive.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Expanded(child: Welcome()),
                  // Expanded(child: LoginForm())
                  Welcome(),
                  LoginForm()
                ]
              ),
            )
          )
        ),
      )
    );
  }
}