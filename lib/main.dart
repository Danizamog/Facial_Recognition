import 'package:flutter/material.dart';
import 'camera_screen.dart';

void main() {
  runApp(const FacialRecognitionApp());
}

class FacialRecognitionApp extends StatelessWidget {
  const FacialRecognitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconocimiento Facial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CameraScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}