part of '../extensions.dart';

/// Makes the result of `Process.run` easier to read.
///
/// ```dart
/// final result = await Process.run('git', ['status', '--short']);
/// if (result.ok) print(result.lines); else fail(result.errors);
/// ```
extension ProcessResultHelpers on ProcessResult {
  /// Turns stdout or stderr into text.
  ///
  /// They are usually text already, but are bytes if `Process.run` was given
  /// `stdoutEncoding: null`.
  String _asText(Object? value) {
    if (value is List<int>) return systemEncoding.decode(value);

    return '${value ?? ''}';
  }

  /// Splits [text] into lines, leaving out empty ones.
  List<String> _splitLines(String text) {
    final result = <String>[];
    for (final line in text.split('\n')) {
      // Windows ends lines with "\r\n", so trim off the "\r" too.
      final trimmed = line.trimRight();
      if (trimmed.isNotEmpty) result.add(trimmed);
    }

    return result;
  }

  /// Whether the program ran successfully
  ///
  /// Whether the exit code is 0
  bool get ok => this.exitCode == 0;

  /// Whether the program ran successfully
  bool get succeeded => ok;

  /// Whether the program failed
  bool get failed => !ok;

  /// Everything the program printed normally (its stdout), as text.
  String get output => _asText(this.stdout);

  /// Everything the program printed as errors (its stderr), as text.
  String get errors => _asText(this.stderr);

  /// The [output] split into lines, with empty lines left out.
  List<String> get lines => _splitLines(output);

  /// The [errors] split into lines, with empty lines left out.
  List<String> get errorLines => _splitLines(errors);

  /// Throws a [ProcessFailed] if the program didn't work.
  ///
  /// Otherwise it gives back this result, so you can write
  /// `(await Process.run('git', ['ls-files'])).throwIfFailed().lines`.
  ProcessResult throwIfFailed() {
    if (!ok) throw ProcessFailed(this);
    return this;
  }
}
