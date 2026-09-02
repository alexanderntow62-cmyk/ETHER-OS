import 'dart:io';

import 'package:video_player/video_player.dart';

class EtherVideoService {
  VideoPlayerController? _controller;

  VideoPlayerController? get controller => _controller;

  Future<VideoPlayerController> initializeFile(String path) async {
    await _controller?.dispose();

    final controller = VideoPlayerController.file(File(path));

    await controller.initialize();

    _controller = controller;

    return controller;
  }

  Future<VideoPlayerController> initializeUrl(String url) async {
    await _controller?.dispose();

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    await controller.initialize();

    _controller = controller;

    return controller;
  }

  Future<void> play() async {
    await _controller?.play();
  }

  Future<void> pause() async {
    await _controller?.pause();
  }

  Future<void> seek(Duration position) async {
    await _controller?.seekTo(position);
  }

  Future<void> setVolume(double volume) async {
    await _controller?.setVolume(volume.clamp(0, 1));
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
