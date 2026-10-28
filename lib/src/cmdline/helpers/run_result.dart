import 'package:cmdline/cmdline.dart';

/// What a program printed and how it finished.
///
/// You get one back from [Executable.capture], [Executable.stream] and the
/// same methods on [Shell].
///
/// ```dart
/// final result = await Executable('git').capture(['status', '--short']);
/// if (result.ok) print(result.lines);
/// ```
class RunResult {
  /// The number the program finished with. 0 usually means it worked.
  final int exitCode;

  /// Everything the program printed normally (its stdout).
  final String output;

  /// Everything the program printed as errors (its stderr).
  final String errors;

  /// Whether the program was stopped because it ran past its timeout.
  final bool timedOut;

  /// Creates a result. Normally only [Executable] does this.
  const RunResult({
    required this.exitCode,
    required this.output,
    required this.errors,
    this.timedOut = false,
  });

  /// Whether the program worked: its [exitCode] is 0 and it didn't time out.
  bool get ok => exitCode == 0 && !timedOut;

  /// The [output] split into lines, with empty lines left out.
  List<String> get lines => _splitLines(output);

  /// The [errors] split into lines, with empty lines left out.
  List<String> get errorLines => _splitLines(errors);

  /// Throws a [RunError] if the program didn't work.
  ///
  /// Otherwise it gives back this result, so you can write
  /// `final files = (await git.capture(['ls-files'])).throwIfFailed().lines;`.
  RunResult throwIfFailed() {
    if (!ok) throw RunError(this);

    return this;
  }

  /// The [output], so a result can be printed directly.
  @override
  String toString() => output;

  /// Splits [text] into lines, leaving out empty ones.
  static List<String> _splitLines(String text) {
    final result = <String>[];
    for (final line in text.split('\n')) {
      // Windows ends lines with "\r\n", so trim off the "\r" too.
      final trimmed = line.trimRight();
      if (trimmed.isNotEmpty) result.add(trimmed);
    }

    return result;
  }
}
