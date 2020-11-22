import 'package:flutter/material.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
// import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalRequestBottomBar extends StatelessWidget {
  const ProfessionalRequestBottomBar({ @required this.services });

  final List<ProfessionalService> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: RoundedButton(
        onPressed: () {
          services.forEach((service) {
            if (service.selected == 1) {
              print('======= ${service.name} =======');
            }
          });
          // Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (Route<dynamic> route) => false);
        }, 
        label: allTranslations.traslate('confirm_request_button_text'),
        backgroundColor: secondaryDarkColor,
        width: double.infinity
      )
    );
  }
}