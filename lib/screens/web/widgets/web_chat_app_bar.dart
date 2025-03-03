import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/info.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.077,
      width: MediaQuery.sizeOf(context).width * 0.75,
      padding: const EdgeInsets.all(10),
      color: webAppBarColor,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0',
            ),
            radius: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            "${info[0]['name']}",
            style: TextTheme.of(context).bodyLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
