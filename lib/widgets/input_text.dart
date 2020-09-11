import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputText extends StatelessWidget {
  final String iconPath, placeholder;
  final double textSize;
  final double iconSize;
  const InputText({Key key, @required this.iconPath, @required this.placeholder, @required this.textSize, @required this.iconSize}) : assert(iconPath != null && placeholder != null) , super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      prefix: Container(
        width: 35,
        height: 25,
        padding: EdgeInsets.all(4),
        child: SvgPicture.asset(
          this.iconPath,
          color: Color(0xffcccccc)
        )
      ),
      placeholder: this.placeholder,
      placeholderStyle: TextStyle(fontSize: 17, fontFamily: 'sans', color: Color(0xffcccccc)),
      style: TextStyle(fontFamily: 'sans'),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1, 
            color: Color(0xffdddddd)
          )
        )
      )
    );
  }
}