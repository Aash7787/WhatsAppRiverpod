import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/enums/message_enum.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/emoji_picker_container.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField(this.receiverUserId, {super.key});
  final String receiverUserId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField>
    with WidgetsBindingObserver {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  late FocusNode focusNode;
  double keyboardHeight = 0;

  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode = FocusNode();
    _messageController = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus && isShowEmojiContainer) {
        setState(() {
          isShowEmojiContainer = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final view = View.of(context);
    final bottomInset = view.viewInsets.bottom;
    final pixelRatio = view.devicePixelRatio;
    setState(() {
      keyboardHeight = bottomInset / pixelRatio;
    });
    super.didChangeMetrics();
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      focusNode.requestFocus(); // show keyboard
      setState(() {
        isShowEmojiContainer = false;
      });
    } else {
      focusNode.unfocus(); // hide keyboard
      setState(() {
        isShowEmojiContainer = true;
      });
    }
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
      setState(() {
        isShowSendButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(keyboardHeight.toString(), name: 'Size');
    return Column(
      children: [
        Row(
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
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        onPressed: selectAndSendVideo,
                        icon: const Icon(
                          Icons.attach_file_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: TextFormField(
                        focusNode: focusNode,
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
                        onPressed: selectAndSendImage,
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
        ),
        isShowEmojiContainer
            ? EmojiPickerContainer(
                isVisible: isShowEmojiContainer,
                keyboardHeight: keyboardHeight,
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _messageController.text += emoji.emoji;
                    isShowSendButton = _messageController.text.isNotEmpty;
                  });
                },
              )
            : const SizedBox()
      ],
    );
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        receiverUserId: widget.receiverUserId,
        messageEnum: messageEnum);
  }

  void selectAndSendImage() async {
    final File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectAndSendGif() async {
    final gif = await pickGif(context);
    if (!mounted) return; // Ensure the widget is still in the tree
    if (gif != null) {
      ref.read(chatControllerProvider).sendGifMessage(
            context,
            gif.url,
            widget.receiverUserId,
          );
    }
  }

  void selectAndSendVideo() async {
    final File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }
}
