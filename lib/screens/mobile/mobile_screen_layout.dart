import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/contacts_list.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/widgets/custom_floating_action_btn.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/mobile/widgets/mobile_screen_app_bar.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  static const route = 'mobile/scree/layout';

  static const _lengthTabController = 3;

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    bool isActive = switch (state) {
      AppLifecycleState.resumed => true,
      AppLifecycleState.paused ||
      AppLifecycleState.inactive ||
      AppLifecycleState.detached ||
      AppLifecycleState.hidden =>
        false,
    };

    if (state == AppLifecycleState.resumed) {
      log('App resumed');
    }

    ref.read(authControllerProvider).setUserState(isActive);
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: MobileScreenLayout._lengthTabController,
      child: Scaffold(
        floatingActionButton: CustomFloatingActionBtn(),
        appBar: MobileScreenAppBar(),
        body: ContactsList(),
      ),
    );
  }
}
