import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: appBarColor,
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (!context.mounted) return image;
    showSnackBar(context, text: e.toString());
  }
  return image;
}
