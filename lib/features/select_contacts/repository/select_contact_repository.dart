import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/models/user_model.dart';

import '../../../common/constants/firebase_string/collections.dart';
import '../../chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider<SelectContactRepository>(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      log('Error of SelectContactRepository');
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact selectedContact) async {
    try {
      String selectedPhoneNum =
          selectedContact.phones[0].number.replaceAll(' ', '');
      QuerySnapshot userQuery = await firestore
          .collection(users)
          .where('phoneNumber', isEqualTo: selectedPhoneNum)
          .get();

      if (!context.mounted) return;

      if (userQuery.docs.isNotEmpty) {
        var document = userQuery.docs.first;
        var userData =
            UserModel.fromMap(document.data() as Map<String, dynamic>);

        Navigator.pushNamed(context, MobileChatScreen.route,
            //  {  'name': userData.name,'uid': userData.uid,},
            arguments: (name: userData.name, uid: userData.uid));
      } else {
        showSnackBar(
          context,
          text:
              'This number does not exist on this app ${selectedContact.phones[0]}',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, text: e.toString());
    }
  }
}
