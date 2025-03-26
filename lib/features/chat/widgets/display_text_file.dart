import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/enums/message_enum.dart';

class DisplayTextFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextFile({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (type == MessageEnum.text) {
          return Text(
            message,
            style: const TextStyle(fontSize: 17, color: Colors.white60),
          );
        } else if (type == MessageEnum.image) {
          return CachedNetworkImage(imageUrl: message);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
