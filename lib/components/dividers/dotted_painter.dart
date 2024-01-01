import 'package:flutter/material.dart';

class DottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFCDCDCD)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
