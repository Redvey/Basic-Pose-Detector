import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final ui.Image image;
  final List<Pose> poses;

  PosePainter(this.image, this.poses);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background image
    canvas.drawImage(image, Offset.zero, Paint());

    // Calculate scale factors
    double scaleX = size.width / image.width;
    double scaleY = size.height / image.height;

    // Paint settings
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (var pose in poses) {
      for (var landmark in pose.landmarks.values) {
        // Scale landmark positions
        final offset = Offset(
          landmark.x * scaleX,
          landmark.y * scaleY,
        );

        canvas.drawCircle(offset, 5, landmarkPaint);
      }
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
