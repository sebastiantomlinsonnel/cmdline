import 'package:cmdline/cmdline.dart';

/// Thrown by [RunResult.throwIfFailed] when a program didn't work.
///
/// Its message shows the exit code and what the program printed as errors.
///
/// ```dart
/// try {
///   (await Executable('git').capture(['pull'])).throwIfFailed();
/// } on RunError catch (error) {
///   fail(error);
/// }
/// ```
class RunError implements Exception {
  /// The result of the program that failed.
  final RunResult result;

  /// Creates the error for a failed [result].
  const RunError(this.result);

  @override
  String toString() {
    final reason = result.timedOut
        ? 'The program took too long and was stopped.'
        : 'The program failed with exit code ${result.exitCode}.';
    final errors = result.errors.trim();
    if (errors.isEmpty) return reason;

    return '$reason\n$errors';
  }
}
