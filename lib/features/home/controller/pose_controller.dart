import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:logger/logger.dart';
import '../../../data/models/pose_state.dart';


final logger = Logger();

final poseControllerProvider =
StateNotifierProvider<PoseController, PoseState?>((ref) {
  return PoseController();
});

class PoseController extends StateNotifier<PoseState?> {
  PoseController() : super(null) {
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  late final PoseDetector _poseDetector;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) await _processImage(File(file.path));
  }

  Future<void> pickImageFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) await _processImage(File(file.path));
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final poses = await _poseDetector.processImage(inputImage);
    final uiImage = await _convertToUIImage(imageFile);

    state = PoseState(
      imageFile: imageFile,
      renderedImage: uiImage,
      poses: poses,
    );
  }

  Future<ui.Image> _convertToUIImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }
}
