part of dartlove;

enum MouseButton {
  left,
  middle,
  right,
  none,
}

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

class _Mouse {
  num getX() => _position.x;
  num getY() => _position.y;
  Point getPosition() => _position;
  bool isDown(MouseButton which) => _down[which] ?? false;
  bool isPressed(MouseButton which) => _pressed[which] ?? false;
  bool isReleased(MouseButton which) => _released[which] ?? false;

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

  void _clearMaps() {
    _pressed.clear();
    _released.clear();
  }

  void _onMouseMove(MouseEvent e) {
    _position = e.client - graphics._canvasPosition;
  }

  void _onMouseDown(MouseEvent e) {
    e.preventDefault();
    _down[_indexToMouseButton(e.button)] = true;
    _pressed[_indexToMouseButton(e.button)] = true;
  }

  void _onMouseUp(MouseEvent e) {
    _down[_indexToMouseButton(e.button)] = false;
    _released[_indexToMouseButton(e.button)] = true;
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
