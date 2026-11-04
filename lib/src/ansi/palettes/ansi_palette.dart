import 'package:cmdline/cmdline.dart';

/// The shared colours for the package's look.
///
/// Soft, slightly muted pastels that read well on dark terminals. The first
/// group is what [Logger.getVerbosityColour] uses for each [Level]; the
/// second group is extra colours in the same style for anything else.
///
/// ```dart
/// print('done'.foreground(AnsiPalette.sky).bold);
/// ```
abstract final class AnsiPalette {
  // ---- Used by the log levels ----

  /// Pink-purple orchid, #DD6EED.
  ///
  /// The colour of [Level.trace].
  static const AnsiColourRgb orchid = AnsiColourRgb.hex(0xDD6EED);

  /// Soft mint green, #8CCCAC.
  ///
  /// The colour of [Level.debug].
  static const AnsiColourRgb mint = AnsiColourRgb.hex(0x8CCCAC);

  /// Muted brick red, #AD3B3B.
  ///
  /// The colour of [Level.fail].
  static const AnsiColourRgb brick = AnsiColourRgb.hex(0xAD3B3B);

  /// Leafy green, #62AF69.
  ///
  /// The colour of [Level.pass].
  static const AnsiColourRgb leaf = AnsiColourRgb.hex(0x62AF69);

  /// Warm amber, #E69E00.
  ///
  /// The colour of [Level.warn].
  static const AnsiColourRgb amber = AnsiColourRgb.hex(0xE69E00);

  /// Off-white, #E6E6E6.
  ///
  /// The colour of [Level.log].
  static const AnsiColourRgb snow = AnsiColourRgb.hex(0xE6E6E6);

  /// Light grey, palette grey step 20.
  ///
  /// The background of [Level.dev] tags.
  static const AnsiColour silver = AnsiColour.grey(20);

  /// Near-black, palette grey step 0.
  ///
  /// The text colour of [Level.dev] tags.
  static const AnsiColour ink = AnsiColour.grey(0);

  // ---- Extra pastels in the same style ----

  /// Soft sky blue, #7FB8E6.
  ///
  /// Good for info, links and headings.
  static const AnsiColourRgb sky = AnsiColourRgb.hex(0x7FB8E6);

  /// Pale lavender, #A99CF0.
  ///
  /// Sits between [sky] and [orchid]; good for secondary highlights.
  static const AnsiColourRgb lavender = AnsiColourRgb.hex(0xA99CF0);

  /// Dusty rose pink, #E88AA8.
  ///
  /// A gentler alternative to [brick] for soft warnings or accents.
  static const AnsiColourRgb rose = AnsiColourRgb.hex(0xE88AA8);

  /// Warm peach, #F2A88A.
  ///
  /// Pairs with [amber]; good for numbers and values.
  static const AnsiColourRgb peach = AnsiColourRgb.hex(0xF2A88A);

  /// Pale butter yellow, #EDD68A.
  ///
  /// A calmer yellow than [amber]; good for notes and tips.
  static const AnsiColourRgb butter = AnsiColourRgb.hex(0xEDD68A);

  /// Soft aqua teal, #7AD4D4.
  ///
  /// Sits between [mint] and [sky]; good for paths and names.
  static const AnsiColourRgb aqua = AnsiColourRgb.hex(0x7AD4D4);

  /// Muted grey-blue slate, #8A94A6.
  ///
  /// For quiet text like hints, borders and timestamps.
  static const AnsiColourRgb slate = AnsiColourRgb.hex(0x8A94A6);
}
