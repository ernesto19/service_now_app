import 'package:flutter/material.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class BusinessDetailBottomBar extends StatelessWidget {
  const BusinessDetailBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 7, left: 5, right: 5),
      child: RoundedButton(
        onPressed: () { }, 
        label: allTranslations.traslate('add_service_label'),
        backgroundColor: secondaryDarkColor,
        width: double.infinity
      )
    );
  }
}