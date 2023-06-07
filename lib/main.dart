import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/ui/screens/camera_page.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CameraPage(cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}
