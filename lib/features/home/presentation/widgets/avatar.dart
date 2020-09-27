import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_now/utils/colors.dart';

class MyAvatar extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;
  const MyAvatar({@required this.onPressed, @required this.name});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: this.onPressed,
      padding: EdgeInsets.zero,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: secondaryColor,
        child: Center(
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ),
    );
  }
}