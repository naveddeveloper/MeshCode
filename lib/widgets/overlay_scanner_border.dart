import 'package:flutter/material.dart';

class QrScannerCornerOverlay extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final Size cutOutSize;

  QrScannerCornerOverlay({
    required this.borderColor,
    required this.borderWidth,
    required this.borderLength,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Calculate the rectangle in the center where scanning occurs.
    final double left = (size.width - cutOutSize.width) / 2;
    final double top = (size.height - cutOutSize.height) / 2;
    final double right = left + cutOutSize.width;
    final double bottom = top + cutOutSize.height;

    // Top-left corner
    canvas.drawLine(Offset(left, top), Offset(left + borderLength, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left, top + borderLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(right, top), Offset(right - borderLength, top), paint);
    canvas.drawLine(Offset(right, top), Offset(right, top + borderLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(left, bottom), Offset(left + borderLength, bottom), paint);
    canvas.drawLine(Offset(left, bottom), Offset(left, bottom - borderLength), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(right, bottom), Offset(right - borderLength, bottom), paint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - borderLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
