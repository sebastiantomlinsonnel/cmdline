import 'dart:convert';
import 'dart:typed_data';

import 'package:cmdline/cmdline.dart';

/// Extensions for working with Strings
extension StringExt on String {
  /// A list of every character
  List<String> get characters => this.split('');

  /// Get a list of every word
  List<String> get words => this.split(' ');

  /// Splits text into lines
  List<String> get lines => const LineSplitter().convert(this);

  /// Gets the character at [index]
  String getChar(int index) => characters.elementAt(index);

  /// Encode as utf8
  Uint8List get utf8Encode => utf8.encode(this);

  /// Whether the string parses as a number.
  ///
  /// Parsing uses [double.tryParse]. `Infinity` and `NaN` are not treated as
  /// numbers. Returns false for null.
  bool isNumeric() {
    if (this == double.infinity.toString() || this == double.nan.toString()) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  /// Whether the string only contains ASCII characters.
  ///
  /// Returns false for null and true for an empty string.
  bool isAscii() {
    for (final s in graphemes(this)) {
      final runes = s.runes;
      if (runes.length != 1) {
        return false;
      }
      final c = runes.first;
      if (c < 0 || c > DEL) {
        return false;
      }
    }
    return true;
  }

  /// Whether this string only contains the digits 0-9.
  ///
  /// Returns false for null and true for an empty string.
  bool isDigits() {
    for (var i = 0; i < this.length; i++) {
      if (!'0123456789'.contains(this[i])) {
        return false;
      }
    }
    return true;
  }

  /// Whether this string contains no upper case letters.
  ///
  /// Returns true for null and for an empty string. A non-ASCII character
  /// counts as upper case when it equals its own [String.toUpperCase], so
  /// caseless characters such as CJK make this return false.
  bool isLowerCase() {
    if (this.isEmpty) return true;

    for (final s in graphemes(this)) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= DEL) {
          if (asciiFlags(c) & UPPER_MASK != 0) {
            return false;
          }
        } else if (s == s.toUpperCase()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Whether [character] is visible when printed to the console.
  ///
  /// Control, format, separator, unassigned, private use and surrogate code
  /// points are not printable. Returns false for null and for values outside
  /// the Unicode range 0..0x10FFFF.
  bool isPrintable(int? character) {
    if (character == null) {
      return false;
    }
    return !isNonPrintable(character);
  }

  /// Whether every character in [string] is whitespace.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline. Returns true for an
  /// empty string.
  bool isWhitespace(String string) {
    for (final element in string.runes) {
      if (!isWhitespaceRune(element)) {
        return false;
      }
    }
    return true;
  }

  /// Whether [rune] is a whitespace character.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline.
  bool isWhitespaceRune(int rune) =>
      (rune >= 0x0009 && rune <= 0x000D) ||
      rune == 0x0020 ||
      rune == 0x0085 ||
      rune == 0x00A0 ||
      rune == 0x1680 ||
      rune == 0x180E ||
      (rune >= 0x2000 && rune <= 0x200A) ||
      rune == 0x2028 ||
      rune == 0x2029 ||
      rune == 0x202F ||
      rune == 0x205F ||
      rune == 0x3000 ||
      rune == 0xFEFF;
}
