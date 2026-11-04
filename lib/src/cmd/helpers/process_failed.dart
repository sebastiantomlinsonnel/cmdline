import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Thrown by [ProcessResultHelpers.throwIfFailed] when a program didn't work.
///
/// Its message shows the exit code and what the program printed as errors.
///
/// ```dart
/// try {
///   (await Process.run('git', ['pull'])).throwIfFailed();
/// } on ProcessFailed catch (error) {
///   fail(error);
/// }
/// ```
class ProcessFailed implements Exception {
  /// The result of the program that failed.
  final ProcessResult result;

  /// Creates the error for a failed [result].
  const ProcessFailed(this.result);

  @override
  String toString() {
    final reason = 'The program failed with exit code ${result.exitCode}.';
    final errors = result.errors.trim();
    if (errors.isEmpty) return reason;

    return '$reason\n$errors';
  }
}
