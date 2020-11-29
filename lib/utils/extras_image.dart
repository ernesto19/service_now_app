import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:service_now/widgets/my_custom_marker.dart';

Future<Uint8List> loadAsset(String path, {int width = 50, int height = 50}) async {
  ByteData data = await rootBundle.load(path);
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width, targetHeight: height);
  
  final ui.FrameInfo frame = await codec.getNextFrame();
  data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return data.buffer.asUint8List();
}

Future<Uint8List> placeToMarker(String title, String duration, String distance) async {
  ui.PictureRecorder recorder = ui.PictureRecorder();
  ui.Canvas canvas = ui.Canvas(recorder);
  final ui.Size size = ui.Size(550, title.length <= 28 ? 150 : 200);
  // MyCustomMarker customMarker = MyCustomMarker(title, duration, distance);
  MyCustomMarker customMarker = MyCustomMarker(title, duration, distance);
  customMarker.paint(canvas, size);
  ui.Picture picture = recorder.endRecording();
  final ui.Image image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );

  final ByteData byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData.buffer.asUint8List();
}