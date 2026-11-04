import 'package:cmdline/cmdline.dart';

/// The shared colours for the package's look.
///
/// Soft, slightly muted pastels that read well on dark terminals. The first
/// group is what [Logger.getVerbosityColour] uses for each [Level]; the
/// second group is extra colours in the same style for anything else.
///
/// ```dart
/// print('done'.foreground(AsciiPalette.sky).bold);
/// ```
abstract final class AsciiPalette {
  // ---- Used by the log levels ----

  /// Pink-purple orchid, #DD6EED.
  ///
  /// The colour of [Level.trace].
  static const AsciiColourRgb orchid = AsciiColourRgb.hex(0xDD6EED);

  /// Soft mint green, #8CCCAC.
  ///
  /// The colour of [Level.debug].
  static const AsciiColourRgb mint = AsciiColourRgb.hex(0x8CCCAC);

  /// Muted brick red, #AD3B3B.
  ///
  /// The colour of [Level.fail].
  static const AsciiColourRgb brick = AsciiColourRgb.hex(0xAD3B3B);

  /// Leafy green, #62AF69.
  ///
  /// The colour of [Level.pass].
  static const AsciiColourRgb leaf = AsciiColourRgb.hex(0x62AF69);

  /// Warm amber, #E69E00.
  ///
  /// The colour of [Level.warn].
  static const AsciiColourRgb amber = AsciiColourRgb.hex(0xE69E00);

  /// Off-white, #E6E6E6.
  ///
  /// The colour of [Level.log].
  static const AsciiColourRgb snow = AsciiColourRgb.hex(0xE6E6E6);

  /// Light grey, palette grey step 20.
  ///
  /// The background of [Level.dev] tags.
  static const AsciiColour silver = AsciiColour.grey(20);

  /// Near-black, palette grey step 0.
  ///
  /// The text colour of [Level.dev] tags.
  static const AsciiColour ink = AsciiColour.grey(0);

  // ---- Extra pastels in the same style ----

  /// Soft sky blue, #7FB8E6.
  ///
  /// Good for info, links and headings.
  static const AsciiColourRgb sky = AsciiColourRgb.hex(0x7FB8E6);

  /// Pale lavender, #A99CF0.
  ///
  /// Sits between [sky] and [orchid]; good for secondary highlights.
  static const AsciiColourRgb lavender = AsciiColourRgb.hex(0xA99CF0);

  /// Dusty rose pink, #E88AA8.
  ///
  /// A gentler alternative to [brick] for soft warnings or accents.
  static const AsciiColourRgb rose = AsciiColourRgb.hex(0xE88AA8);

  /// Warm peach, #F2A88A.
  ///
  /// Pairs with [amber]; good for numbers and values.
  static const AsciiColourRgb peach = AsciiColourRgb.hex(0xF2A88A);

  /// Pale butter yellow, #EDD68A.
  ///
  /// A calmer yellow than [amber]; good for notes and tips.
  static const AsciiColourRgb butter = AsciiColourRgb.hex(0xEDD68A);

  /// Soft aqua teal, #7AD4D4.
  ///
  /// Sits between [mint] and [sky]; good for paths and names.
  static const AsciiColourRgb aqua = AsciiColourRgb.hex(0x7AD4D4);

  /// Muted grey-blue slate, #8A94A6.
  ///
  /// For quiet text like hints, borders and timestamps.
  static const AsciiColourRgb slate = AsciiColourRgb.hex(0x8A94A6);
}
