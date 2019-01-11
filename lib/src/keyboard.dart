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

class _Keyboard {
  bool isDown(String key) => _keysDown[key] ?? false;
  bool isPressed(String key) => _keysPressed[key] ?? false;
  bool isReleased(String key) => _keysReleased[key] ?? false;

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

  void _update() {
    _keysPressed.clear();
    _keysReleased.clear();
  }

  void _onKeyPress(KeyboardEvent e) {
    // this is an important line that prevents the browser from executing whatever the default
    // action is for this key event. (like scrolling down when space is pressed or changing focus with tab)
    e.preventDefault();

    if (e.repeat) return;
    _setMapKey(e, _keysPressed, true);
  }

  void _onKeyDown(KeyboardEvent e) => _setMapKey(e, _keysDown, true);

  void _onKeyUp(KeyboardEvent e) {
    _setMapKey(e, _keysDown, false);
    _setMapKey(e, _keysReleased, true);
  }

  void _setMapKey(KeyboardEvent e, HashMap map, bool value) => 
    map[_lookupTranslatedKey(e.key)] = value; 
}

class LoveKeyboardEvent {
  final String key;
  final bool isRepeat;

  LoveKeyboardEvent._internal(KeyboardEvent e)
      : key = _lookupTranslatedKey(e.key),
        isRepeat = e.repeat;
}
