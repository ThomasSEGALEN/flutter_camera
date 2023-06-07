import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LabelerService {
  late ImageLabeler _imageLabeler;
  final CameraController _controller;
  void Function(List<String>?) onResult;

  LabelerService(this._controller, this.onResult) {
    init();
  }

  Future<void> init() async {
    const path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);

    final optionsLabeler = LocalLabelerOptions(modelPath: modelPath);
    _imageLabeler = ImageLabeler(options: optionsLabeler);

    _controller.startImageStream(processCameraImage);
  }

  Future<List<String>?> processImage(InputImage inputImage) async {
    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final labels = await _imageLabeler.processImage(inputImage);
      final List<String> list = [];
      for (final label in labels) {
        list.add('${label.label} (${label.confidence.toStringAsFixed(2)})');
      }
      return list;
    }
    return null;
  }

  void dispose() {
    _imageLabeler.close();
  }

  Future processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotationValue.fromRawValue(_controller.description.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    final list = await processImage(inputImage);
    onResult(list);
  }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!file.existsSync()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
