import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  static const _name = 'chatController';

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts(){
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverId){
    return chatRepository.getChatStream(receiverId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
  }) {
    log('Function is called $_name', name: _name);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!),
        );
  }
}
