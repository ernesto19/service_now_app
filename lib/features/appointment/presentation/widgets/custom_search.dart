import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/presentation/widgets/custom_app_bar.dart';

class CustomSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 40),
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CustomAppBar()
            )
          ]
        )
      )
    );
  }
}