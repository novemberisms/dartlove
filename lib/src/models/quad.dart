part of dartlove;

class Quad {
  final num startX;
  final num startY;
  final num width;
  final num height;
  final num srcWidth;
  final num srcHeight;

  const Quad(this.startX, this.startY, this.width, this.height, this.srcWidth,
      this.srcHeight);

  Quad.forImage(Image image, this.startX, this.startY, this.width, this.height)
      : srcWidth = image.width,
        srcHeight = image.height;
}
