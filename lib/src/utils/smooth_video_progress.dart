library smooth_video_progress;

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget that provides a method of building widgets using an interpolated
/// position value for [BetterPlayerController].
class SmoothVideoProgress extends HookWidget {
  const SmoothVideoProgress({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });

  /// The [BetterPlayerController] to build a progress widget for.
  final BetterPlayerController controller;

  /// The builder function.
  ///
  /// [progress] holds the interpolated current progress of the video. Use
  /// [duration] (the total duration of the video) to calculate a relative value
  /// for a slider for example for convenience.
  /// [child] holds the widget you passed into the constructor of this widget.
  /// Use that to optimize rebuilds.
  final Widget Function(BuildContext context, Duration progress,
      Duration duration, Widget? child) builder;

  /// An optional child that will be passed to the [builder] function and helps
  /// you optimize rebuilds.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final value = useValueListenable(controller.videoPlayerController!);
    var duration = value.duration ?? Duration.zero;

    final animationController = useAnimationController(
      duration: duration,
      keys: [value.duration ?? Duration.zero],
    );

    final targetRelativePosition =
        value.position.inMilliseconds / duration.inMilliseconds;

    final currentPosition = Duration(
      milliseconds:
          (animationController.value * duration.inMilliseconds).round(),
    );

    final offset = value.position - currentPosition;

    useValueChanged(
      value.position,
      (_, __) {
        final correct = value.isPlaying &&
            offset.inMilliseconds > -500 &&
            offset.inMilliseconds < -50;
        final correction = const Duration(milliseconds: 500) - offset;
        final targetPos =
            correct ? animationController.value : targetRelativePosition;

        animationController.duration =
            correct ? duration + correction : duration;
        value.isPlaying
            ? animationController.forward(from: targetPos)
            : animationController.value = targetRelativePosition;
        return true;
      },
    );

    useValueChanged(
      value.isPlaying,
      (_, __) => value.isPlaying
          ? animationController.forward(from: targetRelativePosition)
          : animationController.stop(),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final millis = animationController.value * duration.inMilliseconds;
        return builder(
          context,
          Duration(milliseconds: millis.round()),
          duration,
          child,
        );
      },
      child: child,
    );
  }
}
