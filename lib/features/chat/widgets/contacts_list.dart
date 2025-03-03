import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/chat_contact.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/info.dart';
import 'package:intl/intl.dart';

const _fileName = 'contacts_list';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWid();
            }
            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(
                indent: 85,
                color: dividerColor,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];

                return ListTileW(
                  record: (
                    name: chatContactData.name,
                    uid: chatContactData.contactId
                  ),
                  info: info,
                  time: chatContactData.timeSent,
                  lastMessage: chatContactData.lastMessage,
                  name: chatContactData.name,
                  profilePic: chatContactData.profilePic,
                );
              },
            );
          }),
    );
  }
}

class ListTileW extends StatelessWidget {
  const ListTileW({
    super.key,
    required this.info,
    required this.name,
    required this.lastMessage,
    required this.profilePic,
    required this.time,
    required this.record,
  });

  final List<Map<String, String>> info;

  final String name;
  final String lastMessage;
  final String profilePic;
  final DateTime time;
  final ({String name, String uid}) record;

  static const errorPicUrl =
      'https://ia601308.us.archive.org/8/items/whatsapp-smiling-guy-i-accidentally-made/whatsapp%20generic%20person%20dark.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: () {
          log('message', name: _fileName);
          Navigator.pushNamed(context, MobileChatScreen.route,
              arguments: record);
        },
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: const CachedNetworkImageProvider(errorPicUrl),
              backgroundColor: Colors.grey,
              foregroundImage: CachedNetworkImageProvider(
                profilePic,
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            // Last message
            child: Text(
              lastMessage,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          trailing: Text(
            DateFormat.Hm().format(time),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
