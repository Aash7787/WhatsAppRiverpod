import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/contacts_list.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/widgets/custom_floating_action_btn.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/widgets/mobile_screen_app_bar.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  static const route = 'mobile/scree/layout';

  static const _lengthTabController = 3;

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: _lengthTabController,
      child: Scaffold(
        floatingActionButton: CustomFloatingActionBtn(),
        appBar: MobileScreenAppBar(),
        body: ContactsList(),
      ),
    );
  }
}
