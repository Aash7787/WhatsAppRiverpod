import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/utils/utils.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/error_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/widgets/loading_wid.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  static const route = '/select/contacts/screen';

  static const _radius = 30.0;

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    try {
      log('selectContact ${selectedContact.phones[0].number}');
    } catch (e) {
      showSnackBar(context,
          text: 'No number found for ${selectedContact.displayName}');
      log('not found');
    }
    ref
        .read(selectContactControllerProvider)
        .selectContact(context, selectedContact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final contact = data[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          // onTap: () => selectContact(ref, contact, context),
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 20),
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Builder(
                              builder: (context) {
                                if (contact.photo == null) {
                                  return const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: _radius,
                                    child: Text('null'),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: _radius,
                                    backgroundImage:
                                        MemoryImage(contact.photo!),
                                  );
                                }
                              },

                              /*  
                            contact.photo == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                  )
                                : CircleAvatar(
                                    backgroundImage: MemoryImage(contact.photo!),
                                  ),
                              */
                            ),
                          )),
                    ),
                  );
                },
              ),
          error: (error, stackTrace) => ErrorWid(
                error: error.toString(),
              ),
          loading: () => const LoadingWid()),
    );
  }
}
