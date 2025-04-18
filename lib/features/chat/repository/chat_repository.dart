import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/enums/message_enum.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/chat_contact.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/message.dart';
import 'package:uuid/uuid.dart';

import '../../../common/constants/firebase_string/collections.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  Stream<List<Message>> getChatStream(String receiverId) {
    return firestore
        .collection(users)
        .doc(auth.currentUser!.uid)
        .collection(chats)
        .doc(receiverId)
        .collection(messages)
        .orderBy(timeSent)
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (final doc in event.docs) {
          messages.add(Message.fromMap(doc.data()));
        }
        return messages;
      },
    );
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required UserModel senderUser}) async {
    try {
      final time = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection(users).doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
          receiverUserData: receiverUserData,
          senderUserData: senderUser,
          timeSent: time,
          text: text);

      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: text,
          timeSent: time,
          messageId: messageId,
          userName: senderUser.name,
          receiverUserName: receiverUserData.name,
          messageType: MessageEnum.text);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: e.toString());
    }
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection(users)
        .doc(auth.currentUser!.uid)
        .collection(chats)
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> contacts = [];
        for (final doc in event.docs) {
          contacts.add(ChatContact.fromMap(doc.data()));
        }
        return contacts;
      },
    );
  }

  void _saveDataToContactsSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required String text,
      required DateTime timeSent}) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection(users)
        .doc(receiverUserData.uid)
        .collection(chats)
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection(users)
        .doc(auth.currentUser!.uid)
        .collection(chats)
        .doc(receiverUserData.uid)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection(users)
        .doc(receiverUserId)
        .collection(chats)
        .doc(auth.currentUser!.uid)
        .collection(messages)
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection(users)
        .doc(auth.currentUser!.uid)
        .collection(chats)
        .doc(receiverUserId)
        .collection(messages)
        .doc(messageId)
        .set(message.toMap());
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required UserModel senderUserData,
      required Ref ref,
      required MessageEnum messageEnum}) async {
    try {
      final timeSent = DateTime.now();

      final messageId = const Uuid().v1();

      final firebaseRef =
          '$chats/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId';

      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(firebaseRef, file);

      final userDataMap =
          await firestore.collection(users).doc(receiverUserId).get();

      final UserModel receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String text = switch (messageEnum) {
        MessageEnum.image => '📷 Photo',
        MessageEnum.audio => '🎤 Audio',
        MessageEnum.video => '🎥 Video',
        MessageEnum.gif => 'Gif',
        _ => file.path,
      };

      _saveDataToContactsSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: text,
          timeSent: timeSent);

      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          messageType: messageEnum);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: '$e sendFileMessage chatRep');
    }
  }

  void sendGifMessage(BuildContext context, String gifUrl,
      String receiverUserId, UserModel senderUserData) async {
    try {
      var messageId = const Uuid().v1();

      final userDataMap =
          await firestore.collection(users).doc(receiverUserId).get();

      final UserModel receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var timeSent = DateTime.now();

      _saveDataToContactsSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: 'Gif',
          timeSent: timeSent);

      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: gifUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          messageType: MessageEnum.gif);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: 'Error, Try again');
    }
  }
}
