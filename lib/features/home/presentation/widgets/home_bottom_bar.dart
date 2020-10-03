import 'package:flutter/material.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: RoundedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (Route<dynamic> route) => false);
        }, 
        label: 'Guardar',
        backgroundColor: secondaryDarkColor,
        width: double.infinity
      )
    );
  }
}