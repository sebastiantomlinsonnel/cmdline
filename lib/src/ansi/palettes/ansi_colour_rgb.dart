import 'package:cmdline/cmdline.dart';

/// An exact 24-bit ("true colour") colour.
///
/// Any of about 16.7 million colours, given as [red], [green] and [blue]
/// from 0 to 255. Most modern terminals support it. Older ones may round it
/// to the nearest palette colour or ignore it, so use [AnsiColour] when
/// compatibility matters.
///
/// ```dart
/// const brand = AnsiColourRgb.hex(0x0B6BCB);
/// print('${brand.fg}hello$RESET');
/// ```
class AnsiColourRgb extends AnsiInk {
  /// Red amount, from 0 to 255.
  ///
  /// 0 is no red, 255 is full red.
  final int red;

  /// Green amount, from 0 to 255.
  ///
  /// 0 is no green, 255 is full green.
  final int green;

  /// Blue amount, from 0 to 255.
  ///
  /// 0 is no blue, 255 is full blue.
  final int blue;

  /// A colour from separate red, green and blue values.
  ///
  /// Each value must be 0 to 255; anything else fails an assert.
  const AnsiColourRgb(this.red, this.green, this.blue)
      : assert(red >= 0 && red <= 255, 'red must be 0-255'),
        assert(green >= 0 && green <= 255, 'green must be 0-255'),
        assert(blue >= 0 && blue <= 255, 'blue must be 0-255');

  /// A colour from a hex number such as `0xFF8800`.
  ///
  /// Reads [value] as `0xRRGGBB`. Anything above the lowest 24 bits is
  /// ignored, so an alpha byte in `0xAARRGGBB` is simply dropped.
  const AnsiColourRgb.hex(int value)
      : red = (value >> 16) & 0xFF,
        green = (value >> 8) & 0xFF,
        blue = value & 0xFF;

  /// `2;<red>;<green>;<blue>`, the true-colour form of the SGR parameters.
  ///
  /// [fg], [bg] and [underline] put this after `38;`, `48;` or `58;`.
  @override
  String get parameters => '2;$red;$green;$blue';

  /// Returns this colour unchanged.
  ///
  /// It's already RGB. Exists so any [AnsiInk] can be converted the same
  /// way.
  @override
  AnsiColourRgb toRgb() => this;

  /// Two RGB colours are equal when all three channels match.
  ///
  /// Never equal to an [AnsiColour]; compare `toRgb()` values for that.
  @override
  bool operator ==(Object other) =>
      other is AnsiColourRgb &&
          other.red == red &&
          other.green == green &&
          other.blue == blue;

  /// Hash of the three channels.
  ///
  /// Matches [operator ==].
  @override
  int get hashCode => Object.hash(red, green, blue);

  /// A readable form for debugging, e.g. `AnsiColourRgb(255, 136, 0)`.
  ///
  /// Not an escape code; use [fg] or [bg] to colour text.
  @override
  String toString() => 'AnsiColourRgb($red, $green, $blue)';
}

/// American-style alias for [AnsiColour], the 256-colour palette.
///
/// Identical type; use whichever name reads better.
typedef Color256 = AnsiColour;

/// Short alias for [AnsiColourRgb], the 24-bit true colour.
///
/// Identical type; use whichever name reads better.
typedef ColorRgb = AnsiColourRgb;

/// American spelling of [AnsiColourRgb].
///
/// Identical type; use whichever name reads better.
typedef AnsiColorRgb = AnsiColourRgb;
