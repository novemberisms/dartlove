part of dartlove;

MouseButton _indexToMouseButton(int index) {
  switch (index) {
    case 0:
      return MouseButton.left;
    case 1:
      return MouseButton.middle;
    case 2:
      return MouseButton.right;
    default:
      return MouseButton.none;
  }
}

class LoveMouseEvent {
  final MouseButton button;
  final Point position;
  LoveMouseEvent._internal(MouseEvent e)
      : button = _indexToMouseButton(e.button),
        position = e.client - graphics._canvasPosition;

  LoveMouseEvent._moved(MouseEvent e)
      : button = MouseButton.none,
        position = e.client - graphics._canvasPosition;
}

enum MouseButton {
  left,
  middle,
  right,
  none,
}

class _Mouse {
  
  Point<num> _position = Point(0.0, 0.0);
  HashMap<MouseButton, bool> _down = HashMap();
  HashMap<MouseButton, bool> _released = HashMap();
  HashMap<MouseButton, bool> _pressed = HashMap();

  _Mouse() {
    window
      ..onMouseMove.listen(_onMouseMove)
      ..onMouseDown.listen(_onMouseDown)
      ..onMouseUp.listen(_onMouseUp);
    print("Mouse initialized");
  }

  /// Returns the current position of the mouse with respect to the origin of the main canvas.
  Point getPosition() => _position;

  /// Gets the current x coordinate of the mouse with respect to the origin of the main canvas.
  num getX() => _position.x;

  /// Gets the current y coordinate of the mouse with respect to the origin of the main canvas.
  num getY() => _position.y;

  /// Returns whether the given `mouseButton` is currently being held down.
  bool isDown(MouseButton mouseButton) => _down[mouseButton] ?? false;

  /// Returns whether the given `mouseButton` has just been pressed down this frame.
  bool isPressed(MouseButton mouseButton) => _pressed[mouseButton] ?? false;

  /// Returns whether the given `mouseButton` has just been released this frame.
  bool isReleased(MouseButton mouseButton) => _released[mouseButton] ?? false;

  void _clearMaps() {
    _pressed.clear();
    _released.clear();
  }

  void _onMouseDown(MouseEvent e) {
    e.preventDefault();
    _down[_indexToMouseButton(e.button)] = true;
    _pressed[_indexToMouseButton(e.button)] = true;
  }

  void _onMouseMove(MouseEvent e) {
    _position = e.client - graphics._canvasPosition;
  }

  void _onMouseUp(MouseEvent e) {
    _down[_indexToMouseButton(e.button)] = false;
    _released[_indexToMouseButton(e.button)] = true;
  }
}
