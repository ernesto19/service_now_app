import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:service_now/utils/app_colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final double width;
  final double fontSize;
  final Widget icon;
  const RoundedButton({Key key, @required this.onPressed, @required this.label, this.backgroundColor, @required this.width, this.fontSize, this.icon }) : assert(label != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            this.icon ?? SizedBox(height: 0),
            Text(
              this.label,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'sans',
                letterSpacing: 1,
                fontSize: this.fontSize ?? 17
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        width: this.width,
        decoration: BoxDecoration(
          color: this.backgroundColor ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5
            )
          ]
        ),
      ), 
      onPressed: this.onPressed
    );
  }
}