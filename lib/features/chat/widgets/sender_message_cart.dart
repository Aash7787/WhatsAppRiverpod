import 'package:flutter/material.dart';
import 'package:flutter_whatsaap_clone_riverpod/common/enums/message_enum.dart';
import 'package:flutter_whatsaap_clone_riverpod/features/chat/widgets/display_text_file.dart';
import 'package:flutter_whatsaap_clone_riverpod/shared/colors.dart';

class SenderMessageCart extends StatelessWidget {
  const SenderMessageCart(
      {super.key,
      required this.message,
      required this.date,
      required this.messageEnum});

  final String message;
  final String date;
  final MessageEnum messageEnum;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: messageEnum.type == MessageEnum.text.type
                ? MediaQuery.sizeOf(context).width - 5
                : MediaQuery.sizeOf(context).width - 55,
            minWidth: messageEnum.type == MessageEnum.text.type ? 110 : 10),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: messageEnum.type == MessageEnum.text.type ? 7 : 5,
                  right: messageEnum.type == MessageEnum.text.type ? 7 : 5,
                  bottom: messageEnum.type == MessageEnum.text.type ? 30 : 25,
                  top: messageEnum.type == MessageEnum.text.type ? 7 : 5,
                ),
                child: DisplayTextFile(message: message, type: messageEnum),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      date,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
