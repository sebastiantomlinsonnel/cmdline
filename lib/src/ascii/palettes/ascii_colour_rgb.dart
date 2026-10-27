import 'package:cmdline/ascii.dart';

/// A 24-bit colour — any of the sixteen million, named by its channels rather

/// than by a slot in a table.
///
/// ```dart
/// print('deep sea'.foreground(const AsciiColourRgb(0x33, 0x66, 0x99)));
/// print('deep sea'.foreground(const AsciiColourRgb.hex(0x336699)));
/// ```
///
/// Terminals that only know the 256-colour table either approximate this to
/// the nearest entry or ignore it. [AsciiColour] is the safer choice where
/// that matters.
class AsciiColourRgb extends AsciiInk {
  /// Red channel, `0`-`255`.
  final int red;

  /// Green channel, `0`-`255`.
  final int green;

  /// Blue channel, `0`-`255`.
  final int blue;

  /// A colour from its three channels, each `0`-`255`.
  const AsciiColourRgb(this.red, this.green, this.blue)
    : assert(red >= 0 && red <= 255, 'red must be 0-255'),
      assert(green >= 0 && green <= 255, 'green must be 0-255'),
      assert(blue >= 0 && blue <= 255, 'blue must be 0-255');

  /// A colour from one `0xRRGGBB` number, the way CSS writes it.
  ///
  /// Only the low 24 bits are read, so an `0xAARRGGBB` value arrives with its
  /// alpha quietly dropped rather than blended.
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

//
// American spellings, for anyone who would rather not type the u. Same classes
// under a second name — drop this block if the package should speak one
// dialect only.
//

/// [AsciiColour] under another name — the 256-colour table.
typedef Color256 = AsciiColour;

/// [AsciiColourRgb] under another name — a 24-bit colour.
typedef ColorRgb = AsciiColourRgb;

/// [AsciiColourRgb] under another name — a 24-bit colour.
typedef AsciiColorRgb = AsciiColourRgb;
