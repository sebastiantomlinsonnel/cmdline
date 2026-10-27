import 'package:cmdline/ascii.dart';

class AsciiColourRgb extends AsciiInk {
  final int red;

  final int green;

  final int blue;

  const AsciiColourRgb(this.red, this.green, this.blue)
    : assert(red >= 0 && red <= 255, 'red must be 0-255'),
      assert(green >= 0 && green <= 255, 'green must be 0-255'),
      assert(blue >= 0 && blue <= 255, 'blue must be 0-255');

  const AsciiColourRgb.hex(int value)
    : red = (value >> 16) & 0xFF,
      green = (value >> 8) & 0xFF,
      blue = value & 0xFF;

  @override
  String get parameters => '2;$red;$green;$blue';

  @override
  AsciiColourRgb toRgb() => this;

  @override
  bool operator ==(Object other) =>
      other is AsciiColourRgb &&
      other.red == red &&
      other.green == green &&
      other.blue == blue;

  @override
  int get hashCode => Object.hash(red, green, blue);

  @override
  String toString() => 'AsciiColourRgb($red, $green, $blue)';
}

typedef Color256 = AsciiColour;

typedef ColorRgb = AsciiColourRgb;

typedef AsciiColorRgb = AsciiColourRgb;
