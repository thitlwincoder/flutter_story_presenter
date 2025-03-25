import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import '../models/story_item.dart';
import '../story_presenter/story_view.dart';
import '../utils/story_utils.dart';
import '../utils/video_utils.dart';

/// A widget that displays a video story view, supporting different video sources
/// (network, file, asset) and optional thumbnail and error widgets.
class VideoStoryView extends StatefulWidget {
  /// The story item containing video data and configuration.
  final StoryItem storyItem;

  /// Callback function to notify when the video is loaded.
  final OnVideoLoad? onVideoLoad;

  /// In case of single video story
  final bool? looping;

  /// Creates a [VideoStoryView] widget.
  const VideoStoryView(
      {required this.storyItem, this.onVideoLoad, this.looping, super.key});

  @override
  State<VideoStoryView> createState() => _VideoStoryViewState();
}

class _VideoStoryViewState extends State<VideoStoryView> {
  late BetterPlayerController controller;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initialiseVideoPlayer();
  }

  /// Initializes the video player controller based on the source of the video.
  Future<void> _initialiseVideoPlayer() async {
    try {
      final storyItem = widget.storyItem;
      if (storyItem.storyItemSource.isNetwork) {
        // Initialize video controller for network source.
        controller = await VideoUtils.instance.videoControllerFromUrl(
          url: storyItem.url!,
          cacheFile: storyItem.videoConfig?.cacheVideo,
          configuration: storyItem.videoConfig!.configuration,
        );
      } else {
        // Initialize video controller for file source.
        controller = VideoUtils.instance.videoControllerFromFile(
          file: File(storyItem.url!),
          configuration: storyItem.videoConfig!.configuration,
        );
      }
      // await videoPlayerController?.initialize();
      widget.onVideoLoad?.call(controller);
      // controller.addEventsListener(eventListener);
      // await controller?.setLooping(widget.looping ?? false);
      // await controller?.setVolume(storyItem.isMuteByDefault ? 0 : 1);
      // if (controller?.videoPlayerController != null) {
      //   controller?.setOverriddenAspectRatio(
      //     controller!.videoPlayerController!.value.aspectRatio,
      //   );
      // }
    } catch (e) {
      hasError = true;
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    // controller?.removeEventsListener(eventListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        if (widget.storyItem.videoConfig?.loadingWidget != null) ...{
          widget.storyItem.videoConfig!.loadingWidget!,
        } else if (widget.storyItem.thumbnail != null) ...{
          // Display the thumbnail if provided.
          widget.storyItem.thumbnail!,
        },
        if (widget.storyItem.errorWidget != null && hasError) ...{
          // Display the error widget if an error occurred.
          widget.storyItem.errorWidget!,
        },
        ...{
          Positioned.fill(
            child: BetterPlayer(controller: controller),
          ),
          // if (widget.storyItem.videoConfig?.useVideoAspectRatio ?? false) ...{
          //   // Display the video with aspect ratio if specified.

          // } else ...{
          //   // Display the video fitted to the screen.
          //   FittedBox(
          //     fit: BoxFit.cover,
          //     alignment: Alignment.center,
          //     child: SizedBox(
          //       width: widget.storyItem.videoConfig?.width ??
          //           videoPlayerController!.value.size.width,
          //       height: widget.storyItem.videoConfig?.height ??
          //           videoPlayerController!.value.size.height,
          //       child: VideoPlayer(videoPlayerController!),
          //     ),
          //   )
          // },
        },
      ],
    );
  }

  // void eventListener(BetterPlayerEvent event) {
  //   if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
  //     if (controller.videoPlayerController != null) {
  //       controller.setOverriddenAspectRatio(
  //         controller.videoPlayerController!.value.aspectRatio,
  //       );
  //     }
  //   }

  //   setState(() {});
  // }
}
