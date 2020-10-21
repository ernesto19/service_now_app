import 'package:flutter/material.dart';

class MyCustomMarker extends CustomPainter {
  final String title;

  MyCustomMarker(this.title);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.green;

    final height = size.height - 15;

    final RRect rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      height,
      Radius.circular(35),
    );
    canvas.drawRRect(rrect, paint);

    final rect = Rect.fromLTWH(size.width / 2 - 2.5, height, 5, 15);

    canvas.drawRect(rect, paint);

    paint.color = Colors.white;

    canvas.drawCircle(
      Offset(30, height / 2),
      12,
      paint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 35,
          color: Colors.white,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width - 65);

    textPainter.paint(
      canvas,
      Offset(60, height / 2 - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}