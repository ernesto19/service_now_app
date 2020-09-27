import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';

import 'avatar.dart';
class HomeHeader extends StatelessWidget {
  final GlobalKey<InnerDrawerState> drawerKey;
  final String name;
  const HomeHeader({Key key, @required this.drawerKey, @required this.name })
      : assert(drawerKey != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 15/8,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                ClipPath(
                  clipper: _MyCustomClipper(),
                  child: Container(
                    color: primaryColor
                  )
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: SafeArea(
                    child: MyAvatar(
                      name: name,
                      onPressed: () {
                        this.drawerKey.currentState.open();
                      }
                    )
                  )
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.25,
                  left: 20,
                  child: Text(
                    allTranslations.traslate('services_title'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'raleway',
                      height: 1
                    )
                  )
                )
              ]
            );
          }
        )
      )
    );
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height * 0.9);
    path.arcToPoint(Offset(size.width, size.height * 0.5),
        radius: Radius.circular(size.width), clockwise: false);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}