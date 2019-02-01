part of dartlove;

abstract class Drawable {
  CanvasImageSource get element;
  num get width;
  num get height;
  bool get loaded;
  num getWidth();
  num getHeight();
  Point getDimensions();
}
