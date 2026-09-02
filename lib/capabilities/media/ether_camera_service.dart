import 'package:camera/camera.dart' as camera;

class EtherCameraService {
  camera.CameraController? _controller;

  camera.CameraController? get controller => _controller;

  bool get isInitialized => _controller?.value.isInitialized ?? false;

  Future<List<camera.CameraDescription>> availableCameras() {
    return camera.availableCameras();
  }

  Future<void> initialize({
    camera.CameraDescription? cameraDescription,
    camera.ResolutionPreset resolution = camera.ResolutionPreset.high,
  }) async {
    final cameras = await camera.availableCameras();

    if (cameras.isEmpty) {
      throw StateError('ETHER: No camera available.');
    }

    final selected = cameraDescription ?? cameras.first;

    final controller = camera.CameraController(
      selected,
      resolution,
      enableAudio: true,
    );

    await controller.initialize();

    await _controller?.dispose();
    _controller = controller;
  }

  Future<camera.XFile> takePhoto() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      throw StateError('ETHER: Camera is not initialized.');
    }

    return controller.takePicture();
  }

  Future<void> startVideoRecording() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      throw StateError('ETHER: Camera is not initialized.');
    }

    if (controller.value.isRecordingVideo) {
      return;
    }

    await controller.startVideoRecording();
  }

  Future<camera.XFile> stopVideoRecording() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      throw StateError('ETHER: Camera is not initialized.');
    }

    if (!controller.value.isRecordingVideo) {
      throw StateError('ETHER: Video recording is not active.');
    }

    return controller.stopVideoRecording();
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
