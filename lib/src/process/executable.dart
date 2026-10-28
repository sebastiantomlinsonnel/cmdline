import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// A program you can run, like `speedtest.exe`, `git` or `dart`.
///
/// Give it a file path, or just a name that is on your PATH. Then pick how to
/// run it:
/// * [run] runs it here in this terminal, with its live output.
/// * [capture] runs it quietly and gives you back what it printed.
/// * [openWindow] opens it in its own new window, like double-clicking it.
///
/// ```dart
/// final git = Executable('git');
/// final result = await git.capture(['status', '--short']);
/// print(result.lines);
/// ```
///
/// If the program can't be found or started, Dart throws a
/// [ProcessException]. For Windows scripts like `flutter` (a `.bat` file), use
/// [Shell] instead.
class Executable {
  /// The program's file path, or its name if it is on your PATH.
  final String path;

  /// The folder the program runs in. When left out, the current folder.
  final String? workingDirectory;

  /// Extra environment variables for the program, like `{'DEBUG': '1'}`.
  final Map<String, String>? environment;

  /// A program at [path], or found on your PATH by name.
  const Executable(this.path, {this.workingDirectory, this.environment});

  /// A program that sits in the same folder as the running script.
  ///
  /// Handy for tools you ship next to your code, like `bin/speedtest.exe`.
  /// If the file isn't there, the plain [fileName] is used, so your PATH is
  /// tried instead.
  factory Executable.nextToScript(String fileName) {
    final file = File.fromUri(Platform.script.resolve(fileName));
    if (file.existsSync()) return Executable(file.path);

    return Executable(fileName);
  }

  /// Runs the program here in this terminal and waits for it to finish.
  ///
  /// The program shares this terminal, so its colours, progress bars and
  /// questions all work. Returns its exit code (0 usually means it worked).
  Future<int> run([List<String> args = const []]) async {
    final process = await Process.start(
      path,
      args,
      workingDirectory: workingDirectory,
      environment: environment,
      mode: ProcessStartMode.inheritStdio,
    );

    return process.exitCode;
  }

  /// Runs the program quietly and gives back what it printed.
  ///
  /// Nothing shows in the terminal while it runs. Pass a [spinner] message
  /// to show a spinner meanwhile; it turns into a PASS or FAIL line at the
  /// end.
  Future<RunResult> capture(List<String> args, {String? spinner}) async {
    if (spinner != null) Logger.instance.startSpinner(spinner);

    final result = await Process.run(
      path,
      args,
      workingDirectory: workingDirectory,
      environment: environment,
    );

    final runResult = RunResult(
      exitCode: result.exitCode,
      output: result.stdout.toString(),
      errors: result.stderr.toString(),
    );

    if (spinner != null) {
      final level = runResult.ok ? Level.pass : Level.fail;
      Logger.instance.stopSpinner(spinner, level);
    }

    return runResult;
  }

  /// Opens the program in its own new terminal window, like double-clicking.
  ///
  /// Returns straight away; the program keeps running in the new window,
  /// which closes when it finishes. Only works on Windows.
  Future<void> openWindow([List<String> args = const []]) async {
    if (!Platform.isWindows) {
      throw UnsupportedError('openWindow only works on Windows.');
    }

    // PowerShell's Start-Process opens a new window. Text goes inside single
    // quotes, and any single quote inside is doubled so it stays text.
    var command = 'Start-Process -FilePath ${_quote(path)}';
    if (workingDirectory != null) {
      command += ' -WorkingDirectory ${_quote(workingDirectory!)}';
    }
    if (args.isNotEmpty) {
      command += ' -ArgumentList ${args.map(_quote).join(',')}';
    }

    await Process.start('powershell', ['-NoProfile', '-Command', command]);
  }

  /// Whether the program can be found, as a file or on your PATH.
  Future<bool> exists() async {
    if (File(path).existsSync()) return true;

    // "where" (Windows) and "which" (Mac and Linux) look through the PATH.
    final finder = Platform.isWindows ? 'where' : 'which';
    final result = await Process.run(finder, [path]);

    return result.exitCode == 0;
  }

  /// Wraps [text] in single quotes for PowerShell.
  String _quote(String text) => "'${text.replaceAll("'", "''")}'";
}
