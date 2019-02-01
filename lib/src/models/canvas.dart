part of dartlove;

class Canvas implements Drawable {
  num get width => element.width;
  num get height => element.height;
  bool get loaded => true;
  final CanvasElement element;
  Canvas(num width, num height)
      : element = CanvasElement(width: width, height: height);
  Canvas.fromElement(this.element) {
    // ugh. the html canvas api is a disaster. this is required or else the pixels
    // will scale such that the canvas screen occupies 300 x 150 pixels no matter what
    element.width = element.scrollWidth;
    element.height = element.scrollHeight;
  }

  num getWidth() => element.width;
  num getHeight() => element.height;
  Point getDimensions() => Point(width, height);

  void renderTo(void fn()) {
    final oldCanvas = graphics.getCanvas();
    graphics.setCanvas(this);
    fn();
    graphics.setCanvas(oldCanvas);
  }
}
