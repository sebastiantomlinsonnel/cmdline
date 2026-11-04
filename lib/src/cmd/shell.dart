part of 'cmd.dart';

class _Shell {
  const _Shell._();

  /// Whether your app is running as administrator (Windows) or root (Mac and
  /// Linux).
  ///
  /// Worked out once and remembered.
  ///
  /// ```dart
  /// if (!await isPrivilegedUser) {
  ///   CliTheme.say(CliTheme.current.errorLine('Please run this as admin'));
  /// }
  /// ```
  Future<bool> get isPrivilegedUser async => await _check();

  /// Runs your app again as administrator or root, with the same arguments.
  ///
  /// On Windows, Windows asks the user first and the app opens in a new
  /// window. Elsewhere it runs through `sudo` in this terminal. Gives back the
  /// new run's exit code; your app should usually exit with it straight after.
  ///
  /// Does nothing and gives back 0 if the app already has these rights.
  ///
  /// ```dart
  /// void main(List<String> args) async {
  ///   if (!await isPrivilegedUser) exit(await withPrivileges(args));
  ///   // ... admin work ...
  /// }
  /// ```
  Future<int> withPrivileges(List<String> arguments) async {
    if (await isPrivilegedUser) return 0;

    final program = Platform.resolvedExecutable;
    final script = Platform.script.toFilePath();
    final isCompiled = script == program || !script.endsWith('.dart');
    final args = [if (!isCompiled) script, ...arguments];

    if (Platform.isWindows) {
      return openInNewWindow(
        program,
        args: args,
        workingDirectory: CMD.fs.pwd,
        asAdmin: true,
        wait: true,
      );
    }

    final process = await Process.start('sudo', [
      program,
      ...args,
    ], mode: ProcessStartMode.inheritStdio);

    return process.exitCode;
  }

  /// Asks the system whether this process has admin or root rights.
  Future<bool> _check() async {
    try {
      if (Platform.isWindows) {
        // "net session" only works for administrators.
        final result = await Process.run('net', ['session']);

        return result.exitCode == 0;
      }
      final result = await Process.run('id', ['-u']);

      return result.output.trim() == '0';
    } on ProcessException {
      return false;
    }
  }
}

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
