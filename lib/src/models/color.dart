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
  const Color.fromRGB(int hex)
      : r = ((hex >> 16) & 0xff) / 255,
        g = ((hex >> 8) & 0xff) / 255,
        b = ((hex >> 0) & 0xff) / 255,
        a = 1;

  static Color get pure_white => const Color.fromRGB(0xffffff);
  static Color get pure_black => const Color.fromRGB(0x000000);
  static Color get pure_red => const Color.fromRGB(0xff0000);
  static Color get pure_green => const Color.fromRGB(0x00ff00);
  static Color get pure_blue => const Color.fromRGB(0x0000ff);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get white => const Color.fromRGB(0xF4F4F4);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get light_grey => const Color.fromRGB(0x93B6C1);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get grey => const Color.fromRGB(0x557185);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get dark_grey => const Color.fromRGB(0x324056);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get black => const Color.fromRGB(0x1A1C2C);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get maroon => const Color.fromRGB(0x572956);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get red => const Color.fromRGB(0xB14156);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get orange => const Color.fromRGB(0xEE7B58);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get yellow => const Color.fromRGB(0xFFD079);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get yellow_green => const Color.fromRGB(0xA0F072);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get green => const Color.fromRGB(0x38B86E);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get blue_green => const Color.fromRGB(0x276E7B);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get dark_blue => const Color.fromRGB(0x29366F);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get blue => const Color.fromRGB(0x405BD0);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get light_blue => const Color.fromRGB(0x4FA4F7);

  /// palette taken from https://lospec.com/palette-list/sweetie-16
  static Color get cyan => const Color.fromRGB(0x86ECF8);

  @override
  bool operator ==(dynamic other) =>
      other is Color && Color.isSame(this, other);

  @override
  int get hashCode => argb;

  @override
  String toString() => "Color($r, $g, $b, $a)";

  static bool isSame(Color a, Color b) =>
      a != null && b != null && a.r == b.r && a.g == b.g && a.b == b.b && a.a == b.a;
}
