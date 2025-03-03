import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) async {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider =
    Provider<SelectContactController>((ref) {
  return SelectContactController(
      ref: ref,
      selectContactRepository: ref.watch(selectContactRepositoryProvider));
});

class SelectContactController {
  final Ref ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(
      {required this.ref, required this.selectContactRepository});
  void selectContact(BuildContext context, Contact selectedContact) {
    selectContactRepository.selectContact(context, selectedContact);
  }
}
