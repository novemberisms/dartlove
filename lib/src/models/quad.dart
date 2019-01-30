part of dartlove;

/// Represents a region inside an image to draw from.
/// 
/// TODO: take into account `scaledWidth` and `scaledHeight` when drawing
class Quad {
  final num startX;
  final num startY;
  final num width;
  final num height;
  final num scaledWidth;
  final num scaledHeight;

  /// The purpose of a quad is to describe the transformation that occurs when you first
  /// scale an image to dimensions `scaledWidth` and `scaledHeight` and *then* take out
  /// from that scaled image a rectangular region whose top left is at (`startX`, `startY`) with `width` and `height`
  const Quad(this.startX, this.startY, this.width, this.height,
      this.scaledWidth, this.scaledHeight);

  /// Create a quad whose `scaledWidth` and `scaledHeight` are the same as the given Image's.
  /// This means that no prescaling is done on the image before taking the rectangular region from it
  Quad.noPrescale(Image image, this.startX, this.startY, this.width, this.height)
      : scaledWidth = image.width,
        scaledHeight = image.height;

  Quad.fromRect(Image image, Rectangle region)
      : startX = region.left,
        startY = region.top,
        width = region.width,
        height = region.height,
        scaledWidth = image.width,
        scaledHeight = image.height;

  Rectangle _getSourceRect() => Rectangle(startX, startY, width, height);
}
