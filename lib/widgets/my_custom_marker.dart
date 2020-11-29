import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyCustomMarker extends CustomPainter {
  final String title;
  final String duration;
  final String distance;

  MyCustomMarker(this.title, this.duration, this.distance);

  void _buildMiniRect(Canvas canvas, Paint paint, double size) {
    paint.color = Colors.black;
    final rect = Rect.fromLTWH(0, 0, size, size);
    canvas.drawRect(rect, paint);
  }

  void _buildParagraph({
    @required Canvas canvas,
    @required List<String> texts,
    @required double width,
    @required Offset offset,
    Color color = Colors.black,
    double fontSize = 18,
    String fontFamily,
    TextAlign textAlign = TextAlign.left,
  }) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        maxLines: 2,
        textAlign: textAlign,
      ),
    );
    builder.pushStyle(
      ui.TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
      ),
    );

    builder.addText(texts[0]);

    if (texts.length > 1) {
      builder.pushStyle(ui.TextStyle(
        fontWeight: FontWeight.bold,
      ));
      builder.addText(texts[1]);
    }

    final ui.Paragraph paragraph = builder.build();

    paragraph.layout(ui.ParagraphConstraints(width: width));
    canvas.drawParagraph(
      paragraph,
      Offset(offset.dx, offset.dy - paragraph.height / 2),
    );
  }

  _shadow(Canvas canvas, double witdh, double height) {
    final path = Path();
    path.lineTo(0, height);
    path.lineTo(witdh, height);
    path.lineTo(witdh, 0);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.white;

    final height = size.height - 15;
    _shadow(canvas, size.width, height);

    final RRect rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      height,
      Radius.circular(0),
    );
    canvas.drawRRect(rrect, paint);

    final rect = Rect.fromLTWH(size.width / 2 - 2.5, height, 5, 15);

    canvas.drawRect(rect, paint);

    _buildMiniRect(canvas, paint, height);

    if (this.duration == null) {
      _buildParagraph(
        canvas: canvas,
        texts: [String.fromCharCode(Icons.gps_fixed.codePoint)],
        width: height,
        fontSize: 40,
        textAlign: TextAlign.center,
        offset: Offset(0, height / 2),
        color: Colors.white,
        fontFamily: Icons.gps_fixed.fontFamily,
      );
    } else {
      var durationSplit = this.duration.replaceFirst('hours', 'H').replaceFirst('mins', 'MIN').split(' ');

      if (durationSplit.length == 2) {
        _buildParagraph(
          canvas: canvas,
          texts: ["${durationSplit[0]}\n", "${durationSplit[1]}"],
          width: height,
          fontSize: 30,
          textAlign: TextAlign.center,
          offset: Offset(1, height / 2),
          color: Colors.white
        );
      } else if (durationSplit.length == 4) {
        _buildParagraph(
          canvas: canvas,
          texts: ["${durationSplit[0]} ${durationSplit[1]}\n", "${durationSplit[2]} ${durationSplit[3]}"],
          width: height,
          fontSize: 30,
          textAlign: TextAlign.center,
          offset: Offset(1, height / 2),
          color: Colors.white
        );
      } else {
        _buildParagraph(
          canvas: canvas,
          texts: ["${this.duration}\n"],
          width: height,
          fontSize: 30,
          textAlign: TextAlign.center,
          offset: Offset(1, height / 2),
          color: Colors.white
        );
      }
    }

    _buildParagraph(
      canvas: canvas,
      texts: ["${this.title.toUpperCase()}\n", "Distancia: ${this.distance}"],
      width: size.width - height - 20,
      offset: Offset(height + 20, height / 2),
      fontSize: 30
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}