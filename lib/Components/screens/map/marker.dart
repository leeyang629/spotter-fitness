import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcon {
  BuildContext context;

  MarkerIcon(BuildContext context) {
    this.context = context;
  }

  BitmapDescriptor markerIcon;

  createMarkerWithText(String text, double size,
      {Color color: const Color.fromRGBO(216, 150, 21, 1)}) async {
    PictureRecorder recorder = new PictureRecorder();
    Canvas canvas = new Canvas(recorder);
    createCanvasDefaultIcon(canvas, size, color: color);
    final textPainter = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: Colors.black,
                fontSize: size,
                fontWeight: FontWeight.bold)),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, 2 * size));

    ByteData pngBytes = await (await recorder
            .endRecording()
            .toImage(6 * (size.toInt()), 4 * (size.toInt())))
        .toByteData(format: ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes.buffer);

    return BitmapDescriptor.fromBytes(data);
  }

  createCanvasDefaultIcon(Canvas canvas, double size, {Color color}) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color != null ? color : Color.fromRGBO(216, 150, 21, 1);
    final whitePaint = Paint()..color = Colors.white;

    double radius = size;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawCircle(Offset(radius, radius), 7, whitePaint);
    final leftriangle = Path();
    leftriangle.moveTo(
        radius - (radius / math.sqrt(2)), radius + (radius / math.sqrt(2)));
    leftriangle.lineTo(radius, radius + (radius / math.sqrt(2)));
    leftriangle.lineTo(radius, radius + (radius * math.sqrt(2)));
    canvas.drawPath(leftriangle, paint);

    final rightpoint = Path();
    rightpoint.moveTo(
        radius + (radius / math.sqrt(2)), radius + (radius / math.sqrt(2)));
    rightpoint.lineTo(radius, radius + (radius / math.sqrt(2)));
    rightpoint.lineTo(radius, radius + (radius * math.sqrt(2)));
    canvas.drawPath(rightpoint, paint);
  }

  createMarkerImageFromAsset() async {
    if (markerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size.square(48));
      return await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/circle-masked.png');
      // CustomPaint()
    }
  }

  // void _updateBitmap(BitmapDescriptor bitmap) {
  //   markerIcon = bitmap;
  // }
}
