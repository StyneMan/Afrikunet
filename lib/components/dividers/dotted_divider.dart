import 'package:flutter/material.dart';

import 'dotted_painter.dart';

class DottedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: DottedPainter(),
      ),
    );
  }
}
