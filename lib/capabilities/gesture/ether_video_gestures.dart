import 'package:flutter/foundation.dart';

class EtherVideoGestureController extends ChangeNotifier {
  double _scale = 1.0;
  double _position = 0.0;
  double _baseScale = 1.0;

  double get scale => _scale;
  double get position => _position;

  void beginScale() {
    _baseScale = _scale;
  }

  void updateScale(double scaleDelta) {
    _scale = (_baseScale * scaleDelta).clamp(1.0, 4.0);
    notifyListeners();
  }

  void resetZoom() {
    _scale = 1.0;
    notifyListeners();
  }

  void swipeHorizontal(double delta) {
    _position += delta;
    notifyListeners();
  }

  void seekForward() {
    _position += 10;
    notifyListeners();
  }

  void seekBackward() {
    _position -= 10;

    if (_position < 0) {
      _position = 0;
    }

    notifyListeners();
  }
}
