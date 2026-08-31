enum EtherGestureType {
  tap,
  doubleTap,
  longPress,
  swipeLeft,
  swipeRight,
  swipeUp,
  swipeDown,
  pinchIn,
  pinchOut,
  pan,
}

class EtherGesture {
  final EtherGestureType type;
  final double dx;
  final double dy;
  final double scale;

  const EtherGesture({
    required this.type,
    this.dx = 0,
    this.dy = 0,
    this.scale = 1,
  });
}
