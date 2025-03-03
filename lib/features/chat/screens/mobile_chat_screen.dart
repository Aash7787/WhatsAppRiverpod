import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/chat_list.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/user_model.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({super.key, required this.name, required this.uid});

  static const route = '/mobile/chat/screen';

  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text(
                        snapshot.data!.isOnline ? "Online" : "Offline",
                        style: const TextStyle(fontSize: 13),
                      )
                    ]),
              );
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatList(uid)),
          BottomChatField(uid),
        ],
      ),
    );
  }
}
