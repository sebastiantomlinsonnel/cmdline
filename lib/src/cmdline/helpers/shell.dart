import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Runs a whole command line, exactly as you'd type it in a terminal.
///
/// Use this for things like `&&`, pipes (`|`) or Windows scripts such as
/// `flutter`. It uses `cmd` on Windows and `sh` on Mac and Linux, so write
/// the command for that system.
///
/// ```dart
/// await Shell.run('dart --version && echo done');
/// final result = await Shell.capture('git log --oneline -3');
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
  /// Pass a [spinner] message to show a spinner while it runs.
  static Future<RunResult> capture(String commandLine, {String? spinner}) =>
      _shell().capture(_args(commandLine), spinner: spinner);

  /// The system's shell program: `cmd` on Windows, `sh` everywhere else.
  static Executable _shell() => Executable(Platform.isWindows ? 'cmd' : 'sh');

  /// The arguments that tell the shell to run [commandLine] and then stop.
  static List<String> _args(String commandLine) =>
      Platform.isWindows ? ['/c', commandLine] : ['-c', commandLine];
}
