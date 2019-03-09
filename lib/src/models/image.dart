part of dartlove;

class Image extends Drawable {
  @override
  final ImageElement element;

  @override
  bool get loaded => _loaded;
  bool _loaded = false;

  @override
  num get width => element.width;

  @override
  num get height => element.height;

  @override
  num getWidth() => element.width;

  @override
  num getHeight() => element.height;

  @override
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
