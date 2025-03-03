import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/message.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/info.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/widgets/receiver_message_cart.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/widgets/sender_message_cart.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerWidget {
  const ChatList(this.receiverId, {super.key});

  final String receiverId;

  @override
  Widget build(BuildContext context, ref) {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).chatStream(receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWid();
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];

              final timeSent = DateFormat.Hm().format(message.timeSent);
              if (messages[index]['isMe'] == true) {
                return SenderMessageCart(
                    message: message.text,
                    date: timeSent);
              } else {
                return ReceiverMessageCart(
                    message: message.text,
                    date: timeSent);
              }
            },
          );
        });
  }
}
