import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/constants/network_images.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  static const route = '/user/information/screen';

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  late TextEditingController nameController;

  File? image;
  bool isLoading = false;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() {
    String name = nameController.text.trim();
    log(name);
    if (name.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 84,
                            backgroundImage: CachedNetworkImageProvider(
                              NetworkImages.personImage,
                            ),
                          )
                        : CircleAvatar(
                            radius: 84,
                            backgroundImage: FileImage(image!),
                          ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: storeUserData,
                      icon: isLoading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.done),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
