import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerContainer extends StatefulWidget {
  const EmojiPickerContainer({
    super.key,
    required this.isVisible,
    required this.keyboardHeight,
    required this.onEmojiSelected,
  });

  final bool isVisible;
  final double keyboardHeight;
  final OnEmojiSelected onEmojiSelected;

  @override
  State<EmojiPickerContainer> createState() => _EmojiPickerContainerState();
}

class _EmojiPickerContainerState extends State<EmojiPickerContainer> {
  @override
  Widget build(BuildContext context) {
    final double height =
        widget.keyboardHeight > 0 ? widget.keyboardHeight : 300;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.isVisible ? height : 0,
      child: widget.isVisible
          ? EmojiPicker(
              onEmojiSelected: widget.onEmojiSelected,
            )
          : null,
    );
  }
}
