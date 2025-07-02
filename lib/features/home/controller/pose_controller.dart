import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

final logger = Logger();

final poseControllerProvider = StateNotifierProvider<PoseController, File?>((ref) {
  return PoseController();
});

class PoseController extends StateNotifier<File?> {
  PoseController() : super(null) {
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  late final PoseDetector _poseDetector;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      final imageFile = File(file.path);
      state = imageFile;
      await _detectPose(imageFile);
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final imageFile = File(file.path);
      state = imageFile;
      await _detectPose(imageFile);
    }
  }

  Future<void> _detectPose(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final poses = await _poseDetector.processImage(inputImage);
    for (Pose pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        logger.i("Detected ${landmark.type.name} at (${landmark.x}, ${landmark.y})");
      });
    }
  }

  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }
}
