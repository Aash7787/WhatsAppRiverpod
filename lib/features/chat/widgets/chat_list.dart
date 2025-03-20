import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/message.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/widgets/receiver_message_cart.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/widgets/sender_message_cart.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList(this.receiverId, {super.key});

  final String receiverId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late final ScrollController _messageScrollController;

  @override
  void initState() {
    super.initState();
    _messageScrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).chatStream(widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWid();
        }

        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) => _messageScrollController.position.maxScrollExtent,
        );

        // WidgetsBinding.instance.addPostFrameCallback(
        //   (timeStamp) => _messageScrollController.position.maxScrollExtent,
        // );

        return ListView.builder(
          controller: _messageScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final message = snapshot.data![index];
            final timeSent = DateFormat.Hm().format(message.timeSent);
            if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return SenderMessageCart(message: message.text, date: timeSent);
            } else {
              return ReceiverMessageCart(message: message.text, date: timeSent);
            }
          },
        );
      },
    );
  }
}
