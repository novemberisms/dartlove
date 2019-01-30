part of dartlove;

class Image {
  final ImageElement element;

  bool get loaded => _loaded;
  bool _loaded = false;

  num get width => element.width;
  num get height => element.height;

  Image(String path) : element = ImageElement(src: path) {
    element.onLoad.listen(_onLoad);
  }

  Image._(String path) : element = ImageElement(src: path);

  static Future<Image> asyncLoad(String path) async {
    final image = Image._(path);
    await for (final e in image.element.onLoad) {
      image._onLoad(e);
      break;
    }
    return image;
  }

  void _onLoad(Event e) {
    _loaded = true;
  }
}