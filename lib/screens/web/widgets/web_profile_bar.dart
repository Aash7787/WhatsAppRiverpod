import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.077,
      width: MediaQuery.sizeOf(context).width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: webAppBarColor,
        border: Border(
          right: BorderSide(color: dividerColor),
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0',
            ),
          ),
          Spacer(),
          Icon(Icons.comment),
          SizedBox(width: 10,),
          Icon(Icons.more_vert)
        ],
      ),
    );
  }
}
