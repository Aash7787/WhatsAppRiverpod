import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart' show appBarColor, tabColor;


class MobileScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MobileScreenAppBar({super.key, this.height = 105});

  final double height;

  static const whatsapp = 'whatsapp';

  static const appBarFontSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text(
          whatsapp,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: appBarFontSize,
              color: Colors.grey),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ),
        ],
        bottom: const TabBar(
            indicatorWeight: 4,
            labelColor: tabColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Chats',
              ),
              Tab(
                text: 'Status',
              ),
              Tab(
                text: 'Calls',
              )
            ]),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
