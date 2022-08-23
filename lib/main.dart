import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main(List<String> args) {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gallery App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
