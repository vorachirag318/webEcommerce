import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerController extends GetxController {
  String? tag;
  String _image = "";

  String get image => _image;

  set image(String value) {
    _image = value;
    update();
  }

  void resetImage() {
    image = "";
  }

  ImagePickerController({this.tag});
}

class AppImagePicker {
  ImagePicker imagePicker = ImagePicker();
  String? tag;
  late ImagePickerController _imagePickerController;
  ImagePickerController get imagePickerController =>
      Get.find<ImagePickerController>(tag: tag);

  AppImagePicker({String? tag}) {
    tag = tag;
    _imagePickerController = Get.put(ImagePickerController(tag: tag), tag: tag);
  }

  update() {
    _imagePickerController.update();
  }

  Future browseImage(ImageSource imageSource) async {
    try {
      var pickedFile =
          await imagePicker.pickImage(source: imageSource, imageQuality: 50);

      File? file = await ImageCropper.cropImage(
        sourcePath: pickedFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Image Cropper",
        ),
      );
      imagePickerController.image = file!.path;
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  Future<void> openBottomSheet() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup<void>(
        context: Get.context as BuildContext,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
                child: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  await browseImage(ImageSource.camera).catchError((e) async {
                    await openAppSettings();
                  });

                  Get.back();
                }),
            CupertinoActionSheetAction(
              child: const Text(
                'Gallery',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                await browseImage(ImageSource.gallery);

                Get.back();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      );
    } else {
      await Get.bottomSheet(
        Wrap(
          children: [
            ListTile(
              leading:  const Icon(Icons.photo_library),
              title:  const Text('Photo Library'),
              tileColor: Colors.white,
              onTap: () async {
                await browseImage(ImageSource.gallery);
                Get.back();
              },
            ),
            const Divider(
              height: 0.5,
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              tileColor: Colors.white,
              onTap: () async {
                final cameraPermissionStatus = await Permission.camera.status;
                if (cameraPermissionStatus.isDenied) {
                  Permission.camera.request().then((value) async {
                    if (value.isPermanentlyDenied) {
                      await openAppSettings();
                    } else if (value.isDenied) {
                      Permission.camera.request();
                    } else if (value.isGranted) {
                      await browseImage(ImageSource.camera);
                    }
                  });
                } else if (cameraPermissionStatus.isRestricted) {
                  await openAppSettings();
                } else if (cameraPermissionStatus.isGranted) {
                  await browseImage(ImageSource.camera);
                }

                Get.back();
              },
            ),
          ],
        ),
        barrierColor: Colors.black.withOpacity(0.3),
      );
    }
  }
}
