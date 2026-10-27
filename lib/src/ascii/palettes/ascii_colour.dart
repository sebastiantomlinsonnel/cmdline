import 'package:cmdline/ascii.dart';

/// One entry of the 256-colour table, which the terminal can paint into any
/// of three places.
///
/// A colour is not a printable code by itself — pick [fg], [bg] or [underline]
/// and you get the string to print. [AsciiColourRgb] is the same idea for the
/// 24-bit colours.
class AsciiColour extends AsciiInk {
  /// Position in the 256-colour table, `0`-`255`.
  final int index;
  // final String fg;

  /// Wraps a table position. The 256 already named are on [colours]; reach for
  /// this only to compute an index.
  const AsciiColour(this.index);

  /// A colour of the 6x6x6 cube, each channel `0`-`5`.
  ///
  /// `AsciiColour.rgb(5, 0, 0)` is full red and `AsciiColour.rgb(5, 5, 5)` is
  /// white — the `rgb_500` and `rgb_555` fields of [colours] under another
  /// name, for when the channels are worked out rather than written down.
  const AsciiColour.rgb(int red, int green, int blue)
    : assert(red >= 0 && red <= 5, 'red must be 0-5'),
      assert(green >= 0 && green <= 5, 'green must be 0-5'),
      assert(blue >= 0 && blue <= 5, 'blue must be 0-5'),
  // fg =
      index = 16 + (36 * red) + (6 * green) + blue;

  /// One of the 24 greys, `0` near-black through `23` near-white.
  ///
  /// The `gray0`-`gray23` fields of [colours] under another name. Neither end
  /// is quite black or quite white; those are `rgb_000` and `rgb_555`.
  const AsciiColour.gray(int step)
    : assert(step >= 0 && step <= 23, 'step must be 0-23'),
      index = 232 + step;

  /// [AsciiColour.gray] under the other spelling.
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

  /// The channels this index paints, as far as they can be known.
  ///
  /// Exact for the 6x6x6 cube and the 24 greys: the table fixes their levels
  /// at `0`, `95`, `135`, `175`, `215`, `255` for the cube and `8` upwards in
  /// tens for the greys. The first sixteen are whatever the terminal theme
  /// says they are, so those come back as xterm's defaults and may be some way
  /// from what is on the screen.
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

/// What the 6x6x6 cube's six steps come out as, in 24-bit terms.
const List<int> _cubeLevels = <int>[0, 95, 135, 175, 215, 255];

/// xterm's defaults for the first sixteen, which every theme is free to
/// overrule. Only used to have something to mix with in [AsciiInk.opacity].
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
