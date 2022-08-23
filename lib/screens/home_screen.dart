import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/screens/image_view.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

ValueNotifier<List<String>> imageListenable = ValueNotifier([]);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takePhoto();
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: ValueListenableBuilder(
          valueListenable: imageListenable,
          builder: (BuildContext context, List<String> value, Widget? child) {
            return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: imageListenable.value.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ImageViewer(
                              path: imageListenable.value[index], tag: index);
                        }));
                      },
                      child: Hero(
                        tag: index,
                        child: FadeInImage(
                          image: FileImage(
                            File(imageListenable.value[index]),
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage('assets/images/black_shade.png'),
                        ),
                      ));
                });
          }),
    );
  }
}

checkPermission() async {
  final status = await Permission.storage.request();
  if (status == PermissionStatus.granted) {
    final path = Directory("storage/emulated/0/Pictures/MyGallery");
    if (!await path.exists()) {
      path.create();
    }
    loadImages();
  }
}

takePhoto() async {
  final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 768,
      maxWidth: 1024);
  if (image == null) return;
  // final permissionStatus = await Permission.storage.request();
  // if (permissionStatus == PermissionStatus.granted) {

  // }
  final path = Directory("storage/emulated/0/Pictures/MyGallery");
  if (await path.exists() != true) {
    path.create();
  }
  File pickedImageFile = File(image.path);
  File newImage = await pickedImageFile.copy(path.path + getNewName());

  imageListenable.value.add(newImage.path);
  imageListenable.notifyListeners();
}

loadImages() async {
  final path = Directory("storage/emulated/0/Pictures/MyGallery");
  List<FileSystemEntity> files = await path.list().toList();
  for (var file in files) {
    if (file.path.toLowerCase().endsWith('.jpg')) {
      imageListenable.value.add(file.path);
    }
  }
  imageListenable.notifyListeners();
  files.clear();
}

String getNewName() {
  final DateTime now = DateTime.now();
  return '/IMG ' + now.toString() + '.jpg';
}
