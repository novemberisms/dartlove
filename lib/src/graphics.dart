part of dartlove;

enum FillStyle { line, fill }
enum TextBaseline { top, bottom, middle, alphabetic, hanging }

const defaultTextBaseline = TextBaseline.top;
const defaultFont = "20px Arial";
final defaultBackgroundColor = Color.light_blue;

class _Graphics {
  CanvasElement _canvas;
  CanvasRenderingContext2D _context;

  Color _color;
  Color _backgroundColor;

  num _width;
  num _height;

  /// used in [_Mouse] as an offset to all mouse positions
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

    _context.font = defaultFont;
    setTextBaseline(defaultTextBaseline);
    setLineWidth(1);
    setColor(Color.white);
    setBackgroundColor(defaultBackgroundColor);
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
    _context.globalAlpha = color.a;
  }

  void resetColor() => setColor(Color.white);

  /// Draws a rectangle with the given style to the screen
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

  void print(String text, num x, num y, [num maxWidth]) {
    _context.fillText(text, x, y, maxWidth);
  }

  void setTextBaseline(TextBaseline baseline) {
    String stringForm;
    switch (baseline) {
      case TextBaseline.top:
        stringForm = "top";
        break;
      case TextBaseline.bottom:
        stringForm = "bottom";
        break;
      case TextBaseline.alphabetic:
        stringForm = "alphabetic";
        break;
      case TextBaseline.middle:
        stringForm = "middle";
        break;
      case TextBaseline.hanging:
        stringForm = "hanging";
        break;
    }
    _context.textBaseline = stringForm;
  }

  void setLineWidth(num width) => _context.lineWidth = width;

  /// draws an [Image] to the canvas
  void draw(Image image, num x, num y,
      [num r = 0, num sx = 1, num sy = 1, num ox = 0, num oy = 0]) {
    if (!image.loaded) return;
    if (r == 0 && sx == 1 && sy == 1) {
      // simplest case. just draw the image offset by the given origins
      _context.drawImage(image.element, x - ox, y - oy);
    } else if (r == 0) {
      // simple case with no rotation. ox and oy need to be multiplied by sx and sy
      // to behave the same way as LOVE does
      _context.drawImageScaled(image.element, x - ox * sx, y - oy * sy,
          image.width * sx, image.height * sy);
    } else {
      // if a rotation is given, we need to translate the canvas, rotate it, and then
      // translate it back, and then draw the image, taking into account origin and scale
      _context.save();
      _context.translate(x, y);
      _context.rotate(r);
      _context.translate(-x, -y);
      _context.drawImageScaled(image.element, x - ox * sx, y - oy * sy,
          image.width * sx, image.height * sy);
      _context.restore();
    }
  }

  /// draws part of an [Image] described by a [Quad] to the canvas
  ///
  /// TODO: take into account the quad's `scaledWidth` and `scaledHeight`
  void drawQuad(Image image, Quad quad, num x, num y,
      [num r = 0, num sx = 1, num sy = 1, num ox = 0, num oy = 0]) {
    if (!image.loaded) return;
    if (r == 0) {
      _context.drawImageScaledFromSource(
          image.element,
          quad.startX,
          quad.startY,
          quad.width,
          quad.height,
          x - ox * sx,
          y - oy * sy,
          quad.width * sx,
          quad.height * sy);
    } else {
      _context.save();
      _context.translate(x, y);
      _context.rotate(r);
      _context.translate(-x, -y);
      _context.drawImageScaledFromSource(
          image.element,
          quad.startX,
          quad.startY,
          quad.width,
          quad.height,
          x - ox * sx,
          y - oy * sy,
          quad.width * sx,
          quad.height * sy);
      _context.restore();
    }
  }

  void drawToRect(Image image, Rectangle destinationRect) {
    if (!image.loaded) return;
    _context.drawImageToRect(image.element, destinationRect);
  }

  void drawQuadToRect(Image image, Quad quad, Rectangle destinationRect) {
    if (!image.loaded) return;
    _context.drawImageToRect(image.element, destinationRect,
        sourceRect: quad._getSourceRect());
  }

  void setBackgroundColor(Color color) => _backgroundColor = color;
  Color getBackgroundColor() => _backgroundColor;

  /// clears the current active canvas
  void clear() {
    _context.save();
    _context.setFillColorRgb(_backgroundColor.r8, _backgroundColor.g8,
        _backgroundColor.b8, _backgroundColor.a);
    _context.fillRect(0, 0, width, height);
    _context.restore();
  }

  /// resets the state of graphics each frame
  void reset() {
    _context.restore();
    setColor(Color.white);
  }

  void push() => _context.save();
  void pop() => _context.restore();
  void translate(num x, num y) => _context.translate(x, y);
  void rotate(num r) => _context.rotate(r);
  void scale(num sx, num sy) => _context.scale(sx, sy);

  Future<Image> newImageAsync(String path) => Image.asyncLoad(path);
  Image newImage(String path) => Image(path);
  Quad newQuad(num x, num y, num w, num h, num sx, num sy) =>
      Quad(x, y, w, h, sx, sy);
}
