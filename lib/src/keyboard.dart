part of dartlove;

final _keyTranslations = <String, String>{
  " ": "space",
  "ArrowLeft": "left",
  "ArrowRight": "right",
  "ArrowUp": "up",
  "ArrowDown": "down",
  "Enter": "enter",
  "Tab": "tab",
  "Escape": "escape",
  "Backspace": "backspace",
};

String _lookupTranslatedKey(String htmlKey) =>
    _keyTranslations[htmlKey] ?? htmlKey;

class LoveKeyboardEvent {
  final String key;
  final bool isRepeat;

  LoveKeyboardEvent._internal(KeyboardEvent e)
      : key = _lookupTranslatedKey(e.key),
        isRepeat = e.repeat;
}

class _Keyboard {
  HashMap<String, bool> _keysDown = HashMap();
  HashMap<String, bool> _keysPressed = HashMap();
  HashMap<String, bool> _keysReleased = HashMap();

  _Keyboard() {
    window
      ..onKeyPress.listen(_onKeyPress)
      ..onKeyDown.listen(_onKeyDown)
      ..onKeyUp.listen(_onKeyUp);
    print("keyboard initialized");
  }

  /// Returns whether the given key is currently being held down. Use `keyboard.isPressed` if you only want to detect
  /// whether the button was pressed down this frame.
  bool isDown(String key) => _keysDown[key] ?? false;

  /// Returns whether the given key has just been pressed down this frame. Use `keyboard.isDown` if you want to check if
  /// the key is currently being held down.
  bool isPressed(String key) => _keysPressed[key] ?? false;

  /// Returns whether the given key has just been released this frame.
  bool isReleased(String key) => _keysReleased[key] ?? false;

  void _clearMaps() {
    _keysPressed.clear();
    _keysReleased.clear();
  }

  void _onKeyDown(KeyboardEvent e) => _setMapKey(e, _keysDown, true);

  void _onKeyPress(KeyboardEvent e) {
    // this is an important line that prevents the browser from executing whatever the default
    // action is for this key event. (like scrolling down when space is pressed or changing focus with tab)
    e.preventDefault();

    if (e.repeat) return;
    _setMapKey(e, _keysPressed, true);
  }

  void _onKeyUp(KeyboardEvent e) {
    _setMapKey(e, _keysDown, false);
    _setMapKey(e, _keysReleased, true);
  }

  void _setMapKey(KeyboardEvent e, HashMap map, bool value) =>
      map[_lookupTranslatedKey(e.key)] = value;
}
