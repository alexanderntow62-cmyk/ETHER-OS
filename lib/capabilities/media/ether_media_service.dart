import 'package:image_picker/image_picker.dart';

class EtherMediaService {
  final ImagePicker _picker;

  EtherMediaService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  Future<XFile?> takePhoto() {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
  }

  Future<XFile?> pickPhoto() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
  }

  Future<XFile?> recordVideo() {
    return _picker.pickVideo(
      source: ImageSource.camera,
    );
  }

  Future<XFile?> pickVideo() {
    return _picker.pickVideo(
      source: ImageSource.gallery,
    );
  }

  Future<List<XFile>> pickPhotos({
    int? limit,
  }) {
    return _picker.pickMultiImage(
      imageQuality: 90,
      limit: limit,
    );
  }
}
