part of dartlove;

enum FillStyle { line, fill }
enum TextBaseline { top, bottom, middle, alphabetic, hanging }

const defaultTextBaseline = TextBaseline.top;
const defaultFont = "20px Arial";
final defaultBackgroundColor = Color.light_blue;

class _Graphics {
  Canvas _mainCanvas;
  Canvas _currentCanvas;
  CanvasRenderingContext2D get _context => _currentCanvas.element.context2D;

  Color _color;
  Color _backgroundColor;

  num _width;
  num _height;

  /// used in [_Mouse] as an offset to all mouse positions
  Point<num> _canvasPosition;

  void _initMainCanvas(CanvasElement canvas) {
    _mainCanvas = Canvas.fromElement(canvas);
    _width = _mainCanvas.width;
    _height = _mainCanvas.height;

    setCanvas(_mainCanvas);

    _canvasPosition = canvas.getBoundingClientRect().topLeft;

    _context.font = defaultFont;
    setTextBaseline(defaultTextBaseline);
    setLineWidth(1);
    setColor(Color.white);
    setBackgroundColor(defaultBackgroundColor);
  }

  void setCanvas([Canvas canvas]) {
    _currentCanvas = canvas ?? _mainCanvas;
  }

  Canvas getCanvas() => _currentCanvas;

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
  num getLineWidth() => _context.lineWidth;

  /// draws a [Drawable] to the active canvas
  void draw(Drawable drawable, num x, num y,
      [num r = 0, num sx = 1, num sy = 1, num ox = 0, num oy = 0]) {
    if (!drawable.loaded) return;
    if (r == 0 && sx == 1 && sy == 1) {
      // simplest case. just draw the drawable offset by the given origins
      _context.drawImage(drawable.element, x - ox, y - oy);
    } else if (r == 0) {
      // simple case with no rotation. ox and oy need to be multiplied by sx and sy
      // to behave the same way as LOVE does
      _context.drawImageScaled(drawable.element, x - ox * sx, y - oy * sy,
          drawable.width * sx, drawable.height * sy);
    } else {
      // if a rotation is given, we need to translate the canvas, rotate it, and then
      // translate it back, and then draw the drawable, taking into account origin and scale
      _context
        ..save()
        ..translate(x, y)
        ..rotate(r)
        ..translate(-x, -y)
        ..drawImageScaled(drawable.element, x - ox * sx, y - oy * sy,
            drawable.width * sx, drawable.height * sy)
        ..restore();
    }
  }

  /// draws part of a [Drawable] described by a [Quad] to the canvas
  ///
  /// TODO: take into account the quad's `scaledWidth` and `scaledHeight`
  void drawQuad(Drawable drawable, Quad quad, num x, num y,
      [num r = 0, num sx = 1, num sy = 1, num ox = 0, num oy = 0]) {
    if (!drawable.loaded) return;
    if (r == 0) {
      _context.drawImageScaledFromSource(
          drawable.element,
          quad.startX,
          quad.startY,
          quad.width,
          quad.height,
          x - ox * sx,
          y - oy * sy,
          quad.width * sx,
          quad.height * sy);
    } else {
      _context
        ..save()
        ..translate(x, y)
        ..rotate(r)
        ..translate(-x, -y)
        ..drawImageScaledFromSource(
            drawable.element,
            quad.startX,
            quad.startY,
            quad.width,
            quad.height,
            x - ox * sx,
            y - oy * sy,
            quad.width * sx,
            quad.height * sy)
        ..restore();
    }
  }

  void drawToRect(Drawable drawable, Rectangle destinationRect) {
    if (!drawable.loaded) return;
    _context.drawImageToRect(drawable.element, destinationRect);
  }

  void drawQuadToRect(Drawable drawable, Quad quad, Rectangle destinationRect) {
    if (!drawable.loaded) return;
    _context.drawImageToRect(drawable.element, destinationRect,
        sourceRect: quad._getSourceRect());
  }

  void setBackgroundColor(Color color) => _backgroundColor = color;
  Color getBackgroundColor() => _backgroundColor;

  /// clears the current active canvas
  void clear([Color clearColor]) {
    final color = clearColor ?? _backgroundColor;
    _context
      ..save()
      ..setFillColorRgb(color.r8, color.g8, color.b8, color.a)
      ..fillRect(0, 0, _currentCanvas.width, _currentCanvas.height)
      ..restore();
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
  Canvas newCanvas(num width, num height) => Canvas(width, height);
}
