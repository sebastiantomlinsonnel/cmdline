import 'dart:convert';
import 'dart:io';

/// Turns a program's output (`process.stdout` or `process.stderr`) into text.
///
/// A program's output arrives as bytes. These turn it into text you can use.
///
/// ```dart
/// final process = await Process.start('git', ['log', '--oneline']);
/// process.stdout.lines.listen(print);
/// ```
extension ProcessOutputHelpers on Stream<List<int>> {
  /// The output one line at a time, as each line is finished.
  ///
  /// The line endings (`\n`, `\r\n` and `\r`) are taken off.
  Stream<String> get lines =>
      transform(systemEncoding.decoder).transform(const LineSplitter());

  /// The output as text, exactly as it arrives.
  ///
  /// Nothing is taken off, so you see every `\r`, `\n` and escape code.
  /// Pieces can stop in the middle of a line.
  Stream<String> get chunks => transform(systemEncoding.decoder);

  /// All of the output as one piece of text, once the program has finished.
  Future<String> get text => chunks.join();
}
