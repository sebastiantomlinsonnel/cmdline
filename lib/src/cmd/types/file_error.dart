import '../../../cmdline.dart';

/// Thrown when a file helper like `copy` or `move` from [CMD.fs] can't do
/// its job.
///
/// [toString] gives plain text for logs. [styled] gives the same message as
/// a coloured error line from [AnsiTheme.current], with the path in bold.
///
/// ```dart
/// try {
///   CMD.fs.copy('a.txt', 'b.txt');
/// } on FileError catch (error) {
///   CliTheme.say(error.styled);
/// }
/// ```
class FileError implements Exception {
  /// What went wrong, without the path.
  final String message;

  /// The file or folder it went wrong for.
  final String path;

  /// Creates the error for [path].
  const FileError(this.message, this.path);

  /// The message as a themed error line, with [path] in bold.
  String get styled {
    final theme = AnsiTheme.current;
    final text = '${theme.cross} $message: '.foreground(theme.error);

    return '$text${path.bold.foreground(theme.error)}';
  }

  @override
  String toString() => '$message: $path';
}
