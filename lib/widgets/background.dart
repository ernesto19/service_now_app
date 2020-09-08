import 'package:flutter/material.dart';
import 'package:service_now/utils/responsive.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive.hp(30),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(60)
        )
      )
    );
  }
}