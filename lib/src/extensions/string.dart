import 'dart:convert';
import 'dart:typed_data';

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
}
