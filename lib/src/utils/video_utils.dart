import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoUtils {
  VideoUtils._();

  // Cache manager to handle caching of video files.
  final _cacheManager = DefaultCacheManager();

  // Singleton instance of VideoUtils.
  static final VideoUtils instance = VideoUtils._();

  // Method to create a VideoPlayerController from a URL.
  // If cacheFile is true, it attempts to cache the video file.
  Future<BetterPlayerController> videoControllerFromUrl({
    required String url,
    bool? cacheFile = false,
    required BetterPlayerConfiguration configuration,
  }) async {
    try {
      File? cachedVideo;
      // If caching is enabled, try to get the cached file.
      if (cacheFile ?? false) {
        cachedVideo = await _cacheManager.getSingleFile(url);
      }
      // If a cached video file is found, create a VideoPlayerController from it.
      if (cachedVideo != null) {
        return BetterPlayerController(
          configuration,
          betterPlayerDataSource: BetterPlayerDataSource.file(cachedVideo.path),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // If no cached file is found, create a VideoPlayerController from the network URL.
    return BetterPlayerController(
      configuration,
      betterPlayerDataSource: BetterPlayerDataSource.network(
        url,
        cacheConfiguration:
            const BetterPlayerCacheConfiguration(useCache: true),
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 15000, // Reduce min buffer size
          maxBufferMs: 50000, // Reduce max buffer size
          bufferForPlaybackMs: 2500,
          bufferForPlaybackAfterRebufferMs: 5000,
        ),
      ),
    );
  }

  // Method to create a VideoPlayerController from a local file.
  BetterPlayerController videoControllerFromFile({
    required File file,
    required BetterPlayerConfiguration configuration,
  }) {
    return BetterPlayerController(
      configuration,
      betterPlayerDataSource: BetterPlayerDataSource.file(file.path),
    );
  }
}
