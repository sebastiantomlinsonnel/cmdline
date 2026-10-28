import 'dart:async';
import 'dart:io';

/// Makes a program started with `Process.start` easier to work with.
///
/// ```dart
/// final process = await Process.start('dart', ['run', 'bin/server.dart']);
/// process.stdout.lines.listen(log);
/// process.writeLine('hello');
/// final code = await process.waitFor(const Duration(seconds: 30));
/// ```
extension ProcessHelpers on Process {
  // Note: "this." is needed below. Without it, `stdin`, `pid` and `exitCode`
  // would mean dart:io's ones for YOUR app, not the started program's.

  /// Types [text] into the program and presses Enter.
  ///
  /// Uses this system's line ending (`\r\n` on Windows, `\n` elsewhere).
  void writeLine(String text) =>
      this.stdin.write('$text${Platform.lineTerminator}');

  /// Tells the program there is nothing more to type in.
  ///
  /// Some programs, like `sort`, wait for this before they finish. It is
  /// safe to call even if the program has already finished.
  Future<void> closeInput() async {
    try {
      await this.stdin.close();
    } catch (_) {
      // The program had already finished, so there was nothing to close.
    }
  }

  /// Stops the program, and any programs it started, and gives back its exit code.
  ///
  /// Plain `kill()` on Windows only stops the program itself, so something
  /// it started (like `ping` inside `cmd`) would keep running.
  Future<int> killTree() async {
    if (Platform.isWindows) {
      // "taskkill /T" also stops the programs this one started.
      await Process.run('taskkill', ['/T', '/F', '/PID', '${this.pid}']);
    } else {
      kill();
    }

    return this.exitCode;
  }

  /// Waits up to [limit] for the program to finish and gives back its exit code.
  ///
  /// If it is still running after [limit], it is stopped with [killTree]
  /// and this gives back null.
  Future<int?> waitFor(Duration limit) async {
    try {
      return await this.exitCode.timeout(limit);
    } on TimeoutException {
      await killTree();

      return null;
    }
  }
}
