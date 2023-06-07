import 'dart:io';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage(this.files, {Key? key}) : super(key: key);

  final List<FileSystemEntity> files;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<FileSystemEntity> pictures = [];

  @override
  void initState() {
    for (var file in widget.files) {
      pictures.add(file);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: pictures.length,
        itemBuilder: (BuildContext context, int index) {
          try {
            return SizedBox(
              width: 100,
              height: 100,
              child: Image.file(
                File(pictures[index].path),
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            );
          } catch (e) {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
