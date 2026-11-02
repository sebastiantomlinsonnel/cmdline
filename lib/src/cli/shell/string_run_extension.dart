import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Runs this string as a terminal command, through [TerminalCommand].
///
/// The command goes to a shell, so pipes, `cd` and variables all work, and
/// the folder carries over between commands. It runs with [env].
///
/// When a command fails, a themed error line is printed and a
/// [ProcessFailed] is thrown, unless you use [start] with `nothrow: true`.
/// In verbose mode ([Logger.verbose]), each command is shown first as a dim
/// `➜ command` line.
///
/// ```dart
/// await 'git pull'.run;
/// final files = await 'git ls-files'.toList();
/// final branch = await 'git branch --show-current'.firstLine;
/// await 'dart test'.forEach((line) => print(line.toUpperCase()));
/// ```
extension StringRun on String {
  /// Runs the command, showing what it prints.
  ///
  /// Throws a [ProcessFailed] if it fails.
  Future<ProcessResult> get run => start();

  /// Runs the command with options.
  ///
  /// * [show]: print what the command prints as it runs.
  /// * [interactive]: hand the keyboard over, for commands that ask things.
  /// * [nothrow]: give back a failed result instead of throwing.
  /// * [shell]: the shell to use. Defaults to [TerminalCommand.defaultShell].
  Future<ProcessResult> start({
    bool show = true,
    bool interactive = false,
    bool nothrow = false,
    TerminalShell? shell,
  }) async {
    final theme = CliTheme.current;
    if (Logger.instance.verbose) {
      CliTheme.say('${theme.pointer} $this'.dim.foreground(theme.hint));
    }

    final result = await TerminalCommand.run(
      this,
      shell: shell,
      show: show,
      interactive: interactive,
    );
    if (result.ok) return result;

    if (show) {
      CliTheme.say(
        theme.errorLine('Failed with exit code ${result.exitCode}: ') +
            '$this'.bold.foreground(theme.error),
      );
    }
    if (!nothrow) throw ProcessFailed(result);

    return result;
  }

  /// Runs the command quietly and gives back the lines it printed.
  ///
  /// Empty lines are left out. Throws a [ProcessFailed] if it fails, unless
  /// [nothrow] is true.
  Future<List<String>> toList({bool nothrow = false}) async =>
      (await start(show: false, nothrow: nothrow)).lines;

  /// Runs the command quietly and gives back the first line it printed.
  ///
  /// Null if it printed nothing. Throws a [ProcessFailed] if it fails.
  Future<String?> get firstLine async {
    final lines = await toList();

    return lines.isEmpty ? null : lines.first;
  }

  /// Runs the command quietly and calls [action] with each line it printed.
  ///
  /// Throws a [ProcessFailed] if it fails.
  Future<void> forEach(void Function(String line) action) async =>
      (await toList()).forEach(action);
}
