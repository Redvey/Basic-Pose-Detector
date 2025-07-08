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

    // Paints
    final landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final leftPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rightPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    void drawCustomLine(Pose pose, PoseLandmarkType p1, PoseLandmarkType p2, Paint paint) {
      final l1 = pose.landmarks[p1];
      final l2 = pose.landmarks[p2];
      if (l1 != null && l2 != null) {
        canvas.drawLine(
          Offset(l1.x * scaleX, l1.y * scaleY),
          Offset(l2.x * scaleX, l2.y * scaleY),
          paint,
        );
      }
    }

    for (var pose in poses) {
      // Draw landmarks
      for (var landmark in pose.landmarks.values) {
        canvas.drawCircle(
          Offset(landmark.x * scaleX, landmark.y * scaleY),
          5,
          landmarkPaint,
        );
      }

      // Arms
      drawCustomLine(pose, PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow, rightPaint);
      drawCustomLine(pose, PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, rightPaint);
      drawCustomLine(pose, PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow, leftPaint);
      drawCustomLine(pose, PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, leftPaint);

      // Torso
      drawCustomLine(pose, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      drawCustomLine(pose, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);
      drawCustomLine(pose, PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, leftPaint);
      drawCustomLine(pose, PoseLandmarkType.rightHip, PoseLandmarkType.leftHip, rightPaint);

      // Legs
      drawCustomLine(pose, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      drawCustomLine(pose, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      drawCustomLine(pose, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      drawCustomLine(pose, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
