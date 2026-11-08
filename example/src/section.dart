import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Prints a heading for one part of the demo, then runs it.
///
/// If the part throws, the error is shown and the demo moves on, so one
/// broken part (no network, no git, ...) never stops the rest.
Future<void> section(String title, FutureOr<void> Function() body) async {
  AnsiTheme.say('');
  AnsiTheme.say(' $title '.bold.inverse.foreground(AnsiTheme.current.highlight));
  try {
    await body();
  } catch (error) {
    fail('$title failed: $error');
  }
}

/// Prints a small heading inside a section.
void heading(String text) {
  AnsiTheme.say('');
  AnsiTheme.say(text.bold.underline);
}

/// Shows rows of "call | result" as a table.
///
/// Used by the demos that are mostly about what a function gives back.
void showCalls(List<List<Object?>> rows) {
  AnsiTheme.say(CMD.draw.table(rows, header: ['Call', 'Result']));
}

/// Writes [text] to [path], making any missing folders first.
///
/// `CMD.fs` has no write helper, so the demos use this one.
void writeFile(String path, String text) {
  File(path)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(text);
}

/// Makes a new empty folder in the system temp folder.
///
/// Every demo that touches files works in one of these and deletes it after.
String tempFolder(String prefix) =>
    Directory.systemTemp
        .createTempSync(prefix)
        .path;
