import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class CustomFloatingActionBtn extends StatelessWidget {
  const CustomFloatingActionBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: tabColor,
      onPressed: () {
        Navigator.pushNamed(context, SelectContactsScreen.route);
      },
      child: const Icon(Icons.comment),
    );
  }
}
