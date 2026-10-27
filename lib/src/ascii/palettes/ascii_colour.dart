import 'package:cmdline/ascii.dart';

class AsciiColour extends AsciiInk {
  final int index;

  const AsciiColour(this.index);

  const AsciiColour.rgb(int red, int green, int blue)
    : assert(red >= 0 && red <= 5, 'red must be 0-5'),
      assert(green >= 0 && green <= 5, 'green must be 0-5'),
      assert(blue >= 0 && blue <= 5, 'blue must be 0-5'),
      index = 16 + (36 * red) + (6 * green) + blue;

  const AsciiColour.gray(int step)
    : assert(step >= 0 && step <= 23, 'step must be 0-23'),
      index = 232 + step;

  const AsciiColour.grey(int step) : this.gray(step);

  @override
  String get parameters => '5;$index';

  @override
  bool operator ==(Object other) =>
      other is AsciiColour && other.index == index;

  @override
  int get hashCode => index;

  @override
  String toString() => 'AsciiColour($index)';

  @override
  AsciiColourRgb toRgb() {
    if (index < 16) return _themeDefaults[index];

    if (index > 231) {
      final int level = 8 + ((index - 232) * 10);

      return AsciiColourRgb(level, level, level);
    }

    final int offset = index - 16;

    return AsciiColourRgb(
      _cubeLevels[offset ~/ 36],
      _cubeLevels[(offset ~/ 6) % 6],
      _cubeLevels[offset % 6],
    );
  }
}

const List<int> _cubeLevels = <int>[0, 95, 135, 175, 215, 255];

const List<AsciiColourRgb> _themeDefaults = <AsciiColourRgb>[
  AsciiColourRgb.hex(0x000000),
  AsciiColourRgb.hex(0xCD0000),
  AsciiColourRgb.hex(0x00CD00),
  AsciiColourRgb.hex(0xCDCD00),
  AsciiColourRgb.hex(0x0000EE),
  AsciiColourRgb.hex(0xCD00CD),
  AsciiColourRgb.hex(0x00CDCD),
  AsciiColourRgb.hex(0xE5E5E5),
  AsciiColourRgb.hex(0x7F7F7F),
  AsciiColourRgb.hex(0xFF0000),
  AsciiColourRgb.hex(0x00FF00),
  AsciiColourRgb.hex(0xFFFF00),
  AsciiColourRgb.hex(0x5C5CFF),
  AsciiColourRgb.hex(0xFF00FF),
  AsciiColourRgb.hex(0x00FFFF),
  AsciiColourRgb.hex(0xFFFFFF),
];
