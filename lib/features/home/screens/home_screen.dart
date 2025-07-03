import 'package:flutter/material.dart';
import '../controller/pose_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/pose_painter.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poseState = ref.watch(poseControllerProvider);
    final controller = ref.read(poseControllerProvider.notifier);
    final height = MediaQuery
        .of(context)
        .size
        .height - 300;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Container(
      margin: const EdgeInsets.only(top: 100),
      height: height,
      child: poseState?.renderedImage != null
          ? FittedBox(
        child: SizedBox(
            width: poseState!.renderedImage!.width.toDouble(),
            height: poseState.renderedImage!.height.toDouble(),
            child: CustomPaint(
            painter: PosePainter(poseState.renderedImage!, poseState.poses),
      ),
    ),
    )
        : Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
    ),
    Padding(
    padding: const EdgeInsets.only(bottom: 30.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    _buildButton(() => controller.pickImageFromGallery(), Icons.photo),
    Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: Colors.limeAccent,
    borderRadius: BorderRadius.circular(50),
    ),
    child: Image.asset('assets/images/logo.png', height: 50, width: 50),
    ),
    _buildButton(() => controller.pickImageFromCamera(), Icons.camera),
    ],
    ),
    ),
    ],
    )
    ,
    );
  }

  Widget _buildButton(VoidCallback onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: Colors.black, size: 30),
      ),
    );
  }
}
