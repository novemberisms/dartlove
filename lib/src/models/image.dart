part of dartlove;

class Image implements Drawable {
  final ImageElement element;

  bool get loaded => _loaded;
  bool _loaded = false;

  num get width => element.width;
  num get height => element.height;
  num getWidth() => element.width;
  num getHeight() => element.height;
  Point getDimensions() => Point(width, height);

  Image(String path) : element = ImageElement(src: path) {
    element.onLoad.listen(_onLoad);
  }

  Image._internal(String path) : element = ImageElement(src: path);

  static Future<Image> asyncLoad(String path) async {
    final image = Image._internal(path);
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
