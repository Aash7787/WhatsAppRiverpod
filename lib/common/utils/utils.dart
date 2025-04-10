import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/constants/api_key.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, {required String text}) {
  if (!context.mounted) return;

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
    showSnackBar(context, text: 'Incorrect image');
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    if (!context.mounted) return video;
    showSnackBar(context, text: 'Incorrect video');
  }
  return video;
}

Future<GiphyGif?> pickGif(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(context: context, apiKey: giphyKey);
  } catch (e) {
    if (!context.mounted) return gif;
    showSnackBar(context, text: 'Gif Error');
  }
  return gif;
}
