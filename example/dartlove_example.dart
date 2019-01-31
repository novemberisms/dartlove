import 'package:dartlove/dartlove.dart';

main() => run(MyApp(), "#canvas");

class MyApp extends LoveApp {
  Image image;
  num x = 0;
  num y = 0;
  num speed = 250;

  @override
  void load() async {
    image = await graphics.newImageAsync("asset/ball.png");
  }

  @override
  void update(num dt) {
    var inputX = 0;
    var inputY = 0;

    if (keyboard.isDown("up")) inputY--;
    if (keyboard.isDown("left")) inputX--;
    if (keyboard.isDown("down")) inputY++;
    if (keyboard.isDown("right")) inputX++;

    x += inputX * speed * dt;
    y += inputY * speed * dt;
  }

  @override
  void draw() {
    graphics.print("Hello World", 10, 10);
    graphics.draw(image, x, y);
  }
}
