import 'package:flutter/material.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ChangePasswordPage extends StatefulWidget {
  static final routeName = 'change_password_page';

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(allTranslations.traslate('cambiar_contrasena'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Container(

      )
    );
  }
}