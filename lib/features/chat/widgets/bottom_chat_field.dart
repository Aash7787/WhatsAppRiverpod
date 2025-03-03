import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField(this.receiverUserId, {super.key});
  final String receiverUserId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;

  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendTextMessage() async {
    if (isShowSendButton && _messageController.text.isNotEmpty) {
      log('message called before');
      ref.read(chatControllerProvider).sendTextMessage(
          context: context,
          text: _messageController.text.trim(),
          receiverUserId: widget.receiverUserId);
      log('message called after receiver id is ${widget.receiverUserId}');
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.075,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                border: Border(
                  bottom: BorderSide(
                    color: dividerColor,
                  ),
                ),
                color: chatBarMessage),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: TextFormField(
                    onFieldSubmitted: (value) => sendTextMessage(),
                    controller: _messageController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isShowSendButton = false;
                        });
                      } else {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: searchBarColor,
                      filled: true,
                      hintText: 'Type message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 10, left: 2),
          child: GestureDetector(
            onTap: sendTextMessage,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF128C7E),
              child: isShowSendButton
                  ? const Icon(Icons.send)
                  : const Icon(Icons.mic),
            ),
          ),
        )
      ],
    );
  }
}
