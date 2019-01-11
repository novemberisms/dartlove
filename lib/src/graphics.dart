part of dartlove;

enum FillStyle { line, fill }

class _Graphics {
  CanvasElement _canvas;
  CanvasRenderingContext2D _context;

  Color _color = Color.white;

  num _width;
  num _height;

  Point<num> _canvasPosition;

  void _initMainCanvas(CanvasElement canvas) {
    _canvas = canvas;
    _context = _canvas.context2D;
    _width = _canvas.scrollWidth.toDouble();
    _height = _canvas.scrollHeight.toDouble();
    // ugh. the html canvas api is a disaster. this is required or else the pixels
    // will scale such that the canvas screen occupies 300 x 150 pixels no matter what
    _canvas.width = _canvas.scrollWidth;
    _canvas.height = _canvas.scrollHeight;

    _canvasPosition = _canvas.getBoundingClientRect().topLeft;
  }

  /// the width of the main canvas
  num get width => _width;

  /// the height of the main canvas
  num get height => _height;

  /// gets the width of the main canvas
  num getWidth() => _width;

  /// gets the height of the main canvas
  num getHeight() => _height;

  void setColor(Color color) {
    if (Color.isSame(color, _color)) return;
    _color = color;
    _context.setFillColorRgb(_color.r8, _color.g8, _color.b8, _color.a);
    _context.setStrokeColorRgb(_color.r8, _color.g8, _color.b8, _color.a);
  }

  void rectangle(FillStyle style, num x, num y, num w, num h) {
    switch (style) {
      case FillStyle.fill:
        return _context.fillRect(x, y, w, h);
      case FillStyle.line:
        return _context.strokeRect(x, y, w, h);
    }
  }

  void line(num x1, num y1, num x2, num y2) => _context
    ..beginPath()
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..stroke();

  void circle(FillStyle style, num x, num y, num r) {
    _context
      ..beginPath()
      ..arc(x, y, r, 0, pi * 2);

    switch (style) {
      case FillStyle.fill:
        return _context.fill();
      case FillStyle.line:
        return _context.stroke();
    }
  }

  void draw(Image image, num x, num y) {
    if (!image.loaded) return;
    _context.drawImage(image.element, x, y);
  }

  void drawQuad(Image image, Quad quad, num x, num y) {
    if (!image.loaded) return;
  }

  /// clears the current active canvas
  void clear() => _context.clearRect(0, 0, width, height);

  /// resets the state of graphics each frame
  void reset() {
    _context.restore();
    setColor(Color.white);
  }

  void push() => _context.save();
  void pop() => _context.restore();

  Future<Image> loadImage(String path) => Image.asyncLoad(path);
  Image newImage(String path) => Image(path);
}


