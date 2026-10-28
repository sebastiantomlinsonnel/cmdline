/// What a program printed and how it finished.
///
/// You get one back from [Executable.capture] and [Shell.capture].
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

  /// Creates a result. Normally only [Executable.capture] does this.
  const RunResult({
    required this.exitCode,
    required this.output,
    required this.errors,
  });

  /// Whether the program worked, which means its [exitCode] is 0.
  bool get ok => exitCode == 0;

  /// The [output] split into lines, with empty lines left out.
  List<String> get lines {
    final result = <String>[];
    for (final line in output.split('\n')) {
      // Windows ends lines with "\r\n", so trim off the "\r" too.
      final trimmed = line.trimRight();
      if (trimmed.isNotEmpty) result.add(trimmed);
    }

    return result;
  }

  /// The [output], so a result can be printed directly.
  @override
  String toString() => output;
}
