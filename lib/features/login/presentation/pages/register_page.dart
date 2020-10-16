import 'package:flutter/material.dart';
import 'package:service_now/features/login/presentation/widgets/register_form.dart';
import 'package:service_now/utils/all_translations.dart';
import '../widgets/welcome.dart';

class RegisterPage extends StatefulWidget {
  static final routeName = 'register_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    Welcome(title: allTranslations.traslate('register')),
                    SizedBox(height: 30),
                    RegisterForm()
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