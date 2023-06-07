import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PicturePage extends StatefulWidget {
  const PicturePage(this.file, {Key? key}) : super(key: key);

  final XFile file;

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture')),
      body: Image.file(File(widget.file.path)),
    );
  }
}
