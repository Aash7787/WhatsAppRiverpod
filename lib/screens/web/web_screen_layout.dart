import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/chat_list.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/contacts_list.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/web/widgets/web_chat_app_bar.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/web/widgets/web_profile_bar.dart';
import 'package:flutter_whatsaap_clone_riverpod/screens/web/widgets/web_search_bar.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';


class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const WebProfileBar(),
                const WebSearchBar(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const Expanded(
                    child: ContactsList(),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: dividerColor)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/backgroundImage.png'),
              ),
            ),
            child: const Column(
              children: [
                WebChatAppBar(),
                Expanded(child: ChatList('')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
