enum ContentAssetType {
  script,
  audio,
  image,
  footage,
  thumbnail,
  caption,
  video,
}

class ContentAsset {
  final String id;
  final ContentAssetType type;
  final String location;
  final bool ready;

  const ContentAsset({
    required this.id,
    required this.type,
    required this.location,
    this.ready = false,
  });
}

class ContentAssetManager {
  final List<ContentAsset> _assets = [];

  List<ContentAsset> get assets => List.unmodifiable(_assets);

  void register(ContentAsset asset) {
    _assets.add(asset);
  }

  bool hasType(ContentAssetType type) =>
      _assets.any((asset) => asset.type == type && asset.ready);
}
