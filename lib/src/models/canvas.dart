part of dartlove;

class Canvas implements Drawable {
  @override
  num get width => element.width;
  @override
  num get height => element.height;
  @override
  bool get loaded => true;
  @override
  final CanvasElement element;
  Canvas(num width, num height)
      : element = CanvasElement(width: width, height: height);
  Canvas.fromElement(this.element) {
    // ugh. the html canvas api is a disaster. this is required or else the pixels
    // will scale such that the canvas screen occupies 300 x 150 pixels no matter what
    element.width = element.scrollWidth;
    element.height = element.scrollHeight;
  }

  @override
  num getWidth() => element.width;
  @override
  num getHeight() => element.height;
  @override
  Point getDimensions() => Point(width, height);

  void renderTo(void fn()) {
    final oldCanvas = graphics.getCanvas();
    graphics.setCanvas(this);
    fn();
    graphics.setCanvas(oldCanvas);
  }
}
