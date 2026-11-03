import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Reads and writes the file whose path is this string.
///
/// Missing parent folders are created when writing.
///
/// ```dart
/// const notes = 'notes.txt';
/// notes.write('First line');
/// notes.append('Second line');
/// print(notes.readLines); // [First line, Second line]
/// notes.truncate();
/// ```
extension StringFile on String {
  /// The whole file as text.
  ///
  /// Throws a [FileError] if there is no file here.
  String get readText {
    if (!CMD.fs.isFile(this)) throw FileError('No file to read', this);

    return File(this).readAsStringSync();
  }

  /// The file's lines, without their line breaks.
  ///
  /// Throws a [FileError] if there is no file here.
  List<String> get readLines {
    if (!CMD.fs.isFile(this)) throw FileError('No file to read', this);

    return File(this).readAsLinesSync();
  }

  /// Replaces the file's text with [text] and a line break.
  ///
  /// Leave out the line break with [newline] set to false.
  void write(String text, {bool newline = true}) {
    _ensureParent();
    File(this).writeAsStringSync(newline ? '$text\n' : text);
  }

  /// Adds [text] and a line break to the end of the file.
  ///
  /// The file is created if it is missing.
  void append(String text, {bool newline = true}) {
    _ensureParent();
    File(this)
        .writeAsStringSync(newline ? '$text\n' : text, mode: FileMode.append);
  }

  /// Empties the file, or creates it empty if it is missing.
  void truncate() {
    _ensureParent();
    File(this).writeAsStringSync('');
  }

  /// Creates the folder this file goes in, if it is missing.
  void _ensureParent() => Directory(dirname(this)).createSync(recursive: true);
}
