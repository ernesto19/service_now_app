import 'package:flutter/material.dart';
import 'package:service_now/features/professional/presentation/pages/professional_service_register_page.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class BusinessDetailBottomBar extends StatelessWidget {
  final int businessId;

  const BusinessDetailBottomBar({ @required this.businessId });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 7, left: 5, right: 5),
      child: RoundedButton(
        label: allTranslations.traslate('add_service_label'),
        backgroundColor: secondaryDarkColor,
        width: double.infinity,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalServiceRegisterPage(businessId: businessId)))
      )
    );
  }
}