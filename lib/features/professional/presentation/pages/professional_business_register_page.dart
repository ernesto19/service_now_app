import 'package:flutter/material.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ProfessionalBusinessRegisterPage extends StatelessWidget {
  static final routeName = 'professional_business_register_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('register_business_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Center(
        child: Text('Registro')
      ),
    );
  }
}