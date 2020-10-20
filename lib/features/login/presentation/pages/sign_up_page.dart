import 'package:flutter/material.dart';
import 'package:service_now/features/login/presentation/widgets/sign_up_form.dart';
import 'package:service_now/utils/all_translations.dart';
import '../widgets/welcome.dart';

class SignUpPage extends StatefulWidget {
  static final routeName = 'register_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(247, 247, 247, 1),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Welcome(title: allTranslations.traslate('register')),
                    SizedBox(height: 30),
                    SignUpForm()
                  ]
                ),
              )
            )
          ),
        ),
      )
    );
  }
}

class Language {
  String title;
  String icon;

  Language({
    this.title,
    this.icon
  });
}