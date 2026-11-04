import 'dart:convert';

/// Extensions for working with Strings
extension StringExt on String {
  /// Gets the character at [index]
  String elementAt(int index) => this.split('').elementAt(index);

  /// Encodes the current string in UTF8
  List<int> toUtf8() => utf8.encode(this);
}
