part of dartlove;

// initialize the modules
_Graphics graphics = _Graphics();
_Keyboard keyboard = _Keyboard();
_Mouse mouse = _Mouse();
_Touch touch = _Touch();

Future run(LoveApp app, [String canvasQuerySelector = "#canvas"]) async {
  // acquire the canvas and initialize
  final mainCanvas = querySelector(canvasQuerySelector);
  mainCanvas.focus();
  graphics._initMainCanvas(mainCanvas);

  // call love.load
  await app.load();

  // main loop time!

  num _prevTime = 0;

  while (true) {
    // this is the new way to do it instead of a setInterval
    final currTime = await window.animationFrame;
    // call love.update
    app.update((currTime - _prevTime) / 1000);
    // reset any transformations or colors
    graphics.reset();
    // clear the main canvas
    graphics.clear();
    // call love.draw
    app.draw();
    // update timer
    _prevTime = currTime;
    // update keyboard state
    keyboard._update();
    // update mouse state
    mouse._update();
  }
}

abstract class LoveApp {
  void load() async {}
  void update(double dt) {}
  void draw() {}
  void keypressed(LoveKeyboardEvent keyEvent) {}
  void keyreleased(LoveKeyboardEvent keyEvent) {}
  void mousemoved(LoveMouseEvent mouseEvent) {}
  void mousepressed(LoveMouseEvent mouseEvent) {}
  void mousereleased(LoveMouseEvent mouseEvent) {}

  LoveApp() {
    window
      ..onKeyPress.listen((e) => keypressed(LoveKeyboardEvent._internal(e)))
      ..onKeyUp.listen((e) => keyreleased(LoveKeyboardEvent._internal(e)))
      ..onMouseMove.listen((e) => mousemoved(LoveMouseEvent._moved(e)))
      ..onMouseDown.listen((e) => mousepressed(LoveMouseEvent._internal(e)))
      ..onMouseUp.listen((e) => mousereleased(LoveMouseEvent._internal(e)));
  }
}