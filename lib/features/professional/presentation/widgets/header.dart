import 'package:flutter/material.dart';
import 'package:service_now/utils/colors.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final double titleSize;
  final Function onTap;

  const Header({ @required this.title, this.subtitle, this.titleSize, @required this.onTap });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 15/7,
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
                  bottom: constraints.maxHeight * 0.6,
                  left: 17,
                  child: GestureDetector(
                    child: Container(
                      child: Icon(Icons.arrow_back, color: Colors.white)
                    ),
                    onTap: onTap
                  ),
                ),
                Positioned(
                  bottom: subtitle == null ? constraints.maxHeight * 0.3 : constraints.maxHeight * 0.4,
                  left: 20,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize ?? 19,
                      fontFamily: 'raleway',
                      height: 1
                    )
                  )
                ),
                subtitle == null ? Container() : Positioned(
                  bottom: constraints.maxHeight * 0.28,
                  left: 20,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
    path.lineTo(0, size.height * 0.8);
    path.arcToPoint(Offset(size.width, size.height * 0.4),
        radius: Radius.circular(size.width), clockwise: false);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}