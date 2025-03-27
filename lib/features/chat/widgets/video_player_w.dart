import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerW extends StatefulWidget {
  const VideoPlayerW({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerW> createState() => _VideoPlayerWState();
}

class _VideoPlayerWState extends State<VideoPlayerW> {
  late CachedVideoPlayerPlusController controller;

  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    controller =
        CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then(
            (value) {},
          );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 14 / 22,
      child: Stack(
        children: [
          CachedVideoPlayerPlus(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isPlay = !isPlay;
                  if (isPlay) {
                    controller.play();
                  } else {
                    controller.pause();
                  }
                });
              },
              icon: isPlay ? const SizedBox() : const Icon(Icons.play_circle),
            ),
          ),
        ],
      ),
    );
  }
}
