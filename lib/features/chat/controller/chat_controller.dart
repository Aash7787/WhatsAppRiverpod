import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/enums/message_enum.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/repository/chat_repository.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/message.dart';

import '../../../models/chat_contact.dart';

final chatControllerProvider = Provider<ChatController>((ref) {
  return ChatController(
      chatRepository: ref.watch(chatRepositoryProvider), ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final Ref ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!),
        );
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required MessageEnum messageEnum}) {
        ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              ref: ref,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageEnum: messageEnum),
        );
      }
}
