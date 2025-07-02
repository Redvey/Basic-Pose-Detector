import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pose Estimation',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker imagePicker;
  File? _image;
  late PoseDetector poseDetector;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    // TODO: Initialize pose detector (if needed)
    final options = PoseDetectorOptions();
    poseDetector = PoseDetector(options: options);
  }

  @override
  void dispose() {
    // TODO: Dispose detector (if needed)
    super.dispose();
  }

  //TODO choose image using camera
  Future<void> _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      doPoseDetection();
    }
  }

  //TODO choose image using gallery
  Future<void> _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      doPoseDetection();
    }
  }

  // Placeholder for pose detection logic
  void doPoseDetection() async{
    // TODO: Implement actual pose detection
    // logger.i("Pose detection would happen here."); // Info level
    // logger.d("Debug log for developer use.");      // Debug level
    // logger.w("Warning level message.");            // Warnings
    // logger.e("Error occurred!");                   // Errors
     InputImage inputImage=InputImage.fromFile(_image!);
     final List<Pose> poses = await poseDetector.processImage(inputImage);

     for (Pose pose in poses) {
       // to access all landmarks
       pose.landmarks.forEach((_, landmark) {
         setState(() {
           _image;
         });
         final type = landmark.type;
         final x = landmark.x;
         final y = landmark.y;
         print("Landmarks: ${landmark.type.name}${landmark.x}${landmark.y}");
       });

       // to access specific landmarks
       final landmark = pose.landmarks[PoseLandmarkType.nose];
     }
  }

  @override
  Widget build(BuildContext context) {
    final double imageAreaHeight = MediaQuery.of(context).size.height - 300;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image display
          Container(
            margin: const EdgeInsets.only(top: 100),
            child: SizedBox(
              height: imageAreaHeight,
              child: _image != null
                  ? Center(child: Image.file(_image!))
                  : Image.asset('assets/bg.jpg', fit: BoxFit.cover),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Button
                _buildButton(
                  onTap: _imgFromGallery,
                  icon: Icons.photo,
                  color: Colors.white,
                ),

                // Center Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.limeAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 50,
                    width: 50,
                  ),
                ),

                // Camera Button
                _buildButton(
                  onTap: _imgFromCamera,
                  icon: Icons.camera_alt,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required VoidCallback onTap, required IconData icon, required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: Colors.black, size: 30),
      ),
    );
  }
}
