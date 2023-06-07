import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class LabelImageWidget extends StatefulWidget {
  const LabelImageWidget(this.cameraController, {Key? key}) : super(key: key);

  final CameraController cameraController;

  @override
  State<LabelImageWidget> createState() => _LabelImageWidgetState();
}

class _LabelImageWidgetState extends State<LabelImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('Label');
  }
}
