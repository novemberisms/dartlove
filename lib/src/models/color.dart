part of dartlove;

class Color {
  final num r, g, b, a;

  int get r8 => (r * 255).floor();
  int get g8 => (g * 255).floor();
  int get b8 => (b * 255).floor();
  int get a8 => (a * 255).floor();
  int get argb => b8 + (g8 << 8) + (r8 << 16) + (a8 << 24);
  int get rgb => b8 + (g8 << 8) + (r8 << 16);
  String get hexStringARGB => argb.toRadixString(16);
  String get hexStringRGB => rgb.toRadixString(16);

  const Color(this.r, this.g, this.b, [this.a = 1.0]);

  static Color get white => const Color(1, 1, 1, 1);
  static Color get black => const Color(0, 0, 0, 1);
  static Color get pure_red => const Color(1, 0, 0, 1);
  static Color get pure_green => const Color(0, 1, 0, 1);
  static Color get pure_blue => const Color(0, 0, 1, 1);

  @override
  bool operator ==(dynamic other) =>
      other is Color && Color.isSame(this, other);

  @override
  int get hashCode => argb;

  @override
  String toString() => "Color($r, $g, $b, $a)";

  static bool isSame(Color a, Color b) =>
      a.r == b.r && a.g == b.g && a.b == b.b && a.a == b.a;
}

Object a;
