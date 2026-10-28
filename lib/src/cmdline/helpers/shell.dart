import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Runs a whole command line, exactly as you'd type it in a terminal.
///
/// Use this for things like `&&` or pipes (`|`). It uses `cmd` on Windows
/// and `sh` on Mac and Linux, so write the command for that system.
///
/// ```dart
/// await Shell.run('dart --version && echo done');
/// final result = await Shell.capture('git log --oneline -3');
/// await Shell.open('https://dart.dev');
/// ```
///
/// For a single program with a list of arguments, [Executable] is safer,
/// because it doesn't need any quoting.
class Shell {
  // Only static methods, so there's nothing to create.
  Shell._();

  /// Runs [commandLine] here in this terminal and waits for it to finish.
  ///
  /// Returns its exit code (0 usually means it worked).
  static Future<int> run(String commandLine) =>
      _shell().run(_args(commandLine));

  /// Runs [commandLine] quietly and gives back what it printed.
  ///
  /// [spinner], [input] and [timeout] work like in [Executable.capture].
  static Future<RunResult> capture(
    String commandLine, {
    String? spinner,
    String? input,
    Duration? timeout,
  }) {
    return _shell().capture(
      _args(commandLine),
      spinner: spinner,
      input: input,
      timeout: timeout,
    );
  }

  /// Runs [commandLine] and hands you each line as soon as it is printed.
  ///
  /// Works like [Executable.stream].
  static Future<RunResult> stream(
    String commandLine, {
    void Function(String line)? onLine,
    void Function(String line)? onErrorLine,
    String? input,
    Duration? timeout,
  }) {
    return _shell().stream(
      _args(commandLine),
      onLine: onLine,
      onErrorLine: onErrorLine,
      input: input,
      timeout: timeout,
    );
  }

  /// Starts [commandLine] in the background and doesn't wait for it.
  ///
  /// Works like [Executable.start].
  static Future<RunningProgram> start(String commandLine) =>
      _shell().start(_args(commandLine));

  /// Starts [commandLine] and lets it keep running after your app ends.
  ///
  /// Works like [Executable.launch].
  static Future<int> launch(String commandLine) =>
      _shell().launch(_args(commandLine));

  /// Opens a file, folder or web address with its usual app.
  ///
  /// Like double-clicking it: a `.txt` file opens in your text editor and a
  /// web address opens in your browser.
  static Future<void> open(String target) async {
    if (Platform.isWindows) {
      // Single quotes keep characters like "&" in web addresses as text.
      final quoted = "'${target.replaceAll("'", "''")}'";
      await Process.run('powershell', [
        '-NoProfile',
        '-Command',
        'Start-Process $quoted',
      ]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [target]);
    } else {
      await Process.run('xdg-open', [target]);
    }
  }

  /// The system's shell program: `cmd` on Windows, `sh` everywhere else.
  static Executable _shell() => Executable(Platform.isWindows ? 'cmd' : 'sh');

  /// The arguments that tell the shell to run [commandLine] and then stop.
  static List<String> _args(String commandLine) =>
      Platform.isWindows ? ['/c', commandLine] : ['-c', commandLine];
}
