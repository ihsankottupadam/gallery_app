import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({required this.path, required this.tag, Key? key})
      : super(key: key);
  final String path;
  final int tag;
  @override
  Widget build(BuildContext context) {
    File imageFile = File(path);
    String fileName = imageFile.path.split('/').last;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.file(File(path)),
        ),
      ),
    );
  }
}
