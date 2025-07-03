import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseState {
  final File imageFile;
  final ui.Image? renderedImage;
  final List<Pose> poses;

  PoseState({
    required this.imageFile,
    this.renderedImage,
    this.poses = const [],
  });
}
