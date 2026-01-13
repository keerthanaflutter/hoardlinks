
import 'package:flutter/material.dart';

class BottomBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // ---------- Light Grey ----------
    paint.color = Colors.grey.shade300;
    final greyPath = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width * 0.65, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(greyPath, paint);

    // ---------- Dark Red ----------
    paint.color = const Color(0xFF5A0E18);
    final darkRedPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.85)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.45, size.height)
      ..close();
    canvas.drawPath(darkRedPath, paint);

    // ---------- Bright Red ----------
    paint.color = const Color(0xFFB11226);
    final redPath = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width * 0.55, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
