import 'package:cmdline/cmdline.dart';

/// A colour from the terminal's 256-colour palette.
///
/// The palette has three parts:
/// * 0 to 15: the standard and bright colours. Their exact shades come from
///   the terminal theme.
/// * 16 to 231: a 6 x 6 x 6 colour cube, built with [AsciiColour.rgb].
/// * 232 to 255: 24 greys from dark to light, built with [AsciiColour.gray].
///
/// Almost every terminal supports this palette. For exact colours use
/// [AsciiColourRgb] instead.
///
/// ```dart
/// const orange = AsciiColour.rgb(5, 2, 0);
/// print('${orange.fg}warning$RESET');
/// ```
class AsciiColour extends AsciiInk {
  /// The palette index, from 0 to 255.
  ///
  /// The unnamed constructor doesn't check the range, so keep it within
  /// 0 to 255 yourself.
  final int index;

  /// A palette colour by its index (0 to 255).
  ///
  /// Use this when you already know the number, e.g. from a colour chart.
  /// The named constructors are easier for cube colours and greys.
  const AsciiColour(this.index);

  /// A colour from the 6 x 6 x 6 colour cube (indexes 16 to 231).
  ///
  /// [red], [green] and [blue] each go from 0 (none) to 5 (full); anything
  /// else fails an assert. The steps are not even: 0, 95, 135, 175, 215 and
  /// 255 out of 255.
  const AsciiColour.rgb(int red, int green, int blue)
    : assert(red >= 0 && red <= 5, 'red must be 0-5'),
      assert(green >= 0 && green <= 5, 'green must be 0-5'),
      assert(blue >= 0 && blue <= 5, 'blue must be 0-5'),
      index = 16 + (36 * red) + (6 * green) + blue;

  /// A grey from the 24-step grey ramp (indexes 232 to 255).
  ///
  /// [step] goes from 0 (almost black, #080808) to 23 (almost white,
  /// #EEEEEE); anything else fails an assert. For pure black or white use
  /// `AsciiColour(16)` or `AsciiColour(231)`.
  const AsciiColour.gray(int step)
    : assert(step >= 0 && step <= 23, 'step must be 0-23'),
      index = 232 + step;

  /// British spelling of [AsciiColour.gray].
  ///
  /// Same grey ramp, same [step] range of 0 to 23.
  const AsciiColour.grey(int step) : this.gray(step);

  /// `5;<index>`, the 256-colour form of the SGR colour parameters.
  ///
  /// [fg], [bg] and [underline] put this after `38;`, `48;` or `58;`.
  @override
  String get parameters => '5;$index';

  /// Two palette colours are equal when they have the same [index].
  ///
  /// An [AsciiColour] is never equal to an [AsciiColourRgb], even if they
  /// look the same; compare their [toRgb] values for that.
  @override
  bool operator ==(Object other) =>
      other is AsciiColour && other.index == index;

  /// The [index], which is already unique per colour.
  ///
  /// Matches [operator ==].
  @override
  int get hashCode => index;

  /// A readable form for debugging, e.g. `AsciiColour(196)`.
  ///
  /// Not an escape code; use [fg] or [bg] to colour text.
  @override
  String toString() => 'AsciiColour($index)';

  /// The palette colour as red, green and blue values (0 to 255 each).
  ///
  /// Uses the standard xterm values: typical theme defaults for 0 to 15, the
  /// cube levels for 16 to 231, and `8 + step * 10` for the greys. Real
  /// terminals may draw 0 to 15 differently.
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

/// Brightness of each of the 6 colour-cube steps, from 0 to 255.
///
/// Step 0 is off; steps 1 to 5 go up in jumps of 40 from 95. Used by
/// [AsciiColour.toRgb] for indexes 16 to 231.
const List<int> _cubeLevels = <int>[0, 95, 135, 175, 215, 255];

/// Typical RGB values for palette colours 0 to 15.
///
/// These are xterm's defaults. Terminal themes usually change these 16
/// colours, so treat them as an estimate. Used by [AsciiColour.toRgb].
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
