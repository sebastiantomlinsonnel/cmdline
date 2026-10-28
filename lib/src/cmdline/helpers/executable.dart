import 'dart:convert';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// A program you can run, like `speedtest.exe`, `git` or `dart`.
///
/// Give it a file path, or just a name that is on your PATH. Then pick how to
/// run it:
/// * [run] runs it here in this terminal, with its live output.
/// * [capture] runs it quietly and gives you back what it printed.
/// * [stream] runs it and hands you each line as it is printed.
/// * [start] runs it in the background, so you can talk to it or stop it.
/// * [launch] starts it and lets it keep running after your app ends.
/// * [openWindow] opens it in its own new window, like double-clicking it.
///
/// ```dart
/// final git = Executable('git');
/// final result = await git.capture(['status', '--short']);
/// print(result.lines);
/// ```
///
/// If the program can't be found or started, Dart throws a
/// [ProcessException]. For Windows scripts like `flutter` (a `.bat` file),
/// set [inShell] to true.
class Executable {
  /// The program's file path, or its name if it is on your PATH.
  final String path;

  /// The folder the program runs in. When left out, the current folder.
  final String? workingDirectory;

  /// Extra environment variables for the program, like `{'DEBUG': '1'}`.
  final Map<String, String>? environment;

  /// Whether to start the program through the system shell.
  ///
  /// Needed on Windows for `.bat` and `.cmd` scripts, like `flutter`.
  final bool inShell;

  /// A program at [path], or found on your PATH by name.
  const Executable(
    this.path, {
    this.workingDirectory,
    this.environment,
    this.inShell = false,
  });

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
    final process = await _start(args, ProcessStartMode.inheritStdio);

    return process.exitCode;
  }

  /// Runs the program quietly and gives back what it printed.
  ///
  /// Nothing shows in the terminal while it runs.
  /// * [spinner]: a message to show with a spinner meanwhile. It turns into a
  ///   PASS or FAIL line at the end.
  /// * [input]: text to type into the program, like `'yes\n'`.
  /// * [timeout]: the longest the program may run. After that it is stopped
  ///   and the result's [RunResult.timedOut] is true.
  Future<RunResult> capture(
    List<String> args, {
    String? spinner,
    String? input,
    Duration? timeout,
  }) async {
    if (spinner != null) Logger.instance.startSpinner(spinner);

    final result = await _collect(
      args,
      input: input,
      timeout: timeout,
      onLine: (_) {},
      onErrorLine: (_) {},
    );

    if (spinner != null) {
      final level = result.ok ? Level.pass : Level.fail;
      Logger.instance.stopSpinner(spinner, level);
    }

    return result;
  }

  /// Runs the program and hands you each line as soon as it is printed.
  ///
  /// [onLine] gets each normal line and [onErrorLine] each error line. When
  /// left out, the lines are printed. Everything is also collected, so you
  /// get the full [RunResult] at the end. [input] and [timeout] work like in
  /// [capture].
  ///
  /// ```dart
  /// await Executable('git').stream(['clone', url], onLine: (line) => log(line));
  /// ```
  Future<RunResult> stream(
    List<String> args, {
    void Function(String line)? onLine,
    void Function(String line)? onErrorLine,
    String? input,
    Duration? timeout,
  }) {
    return _collect(
      args,
      input: input,
      timeout: timeout,
      onLine: onLine ?? stdout.writeln,
      onErrorLine: onErrorLine ?? stderr.writeln,
    );
  }

  /// Starts the program in the background and doesn't wait for it.
  ///
  /// Use the [RunningProgram] you get back to read its lines, type into it,
  /// wait for it or stop it.
  Future<RunningProgram> start([List<String> args = const []]) async {
    final process = await _start(args, ProcessStartMode.normal);

    return RunningProgram(process);
  }

  /// Starts the program and lets it keep running after your app ends.
  ///
  /// You can't see its output. Returns its process id.
  Future<int> launch([List<String> args = const []]) async {
    final process = await _start(args, ProcessStartMode.detached);

    return process.pid;
  }

  /// Opens the program in its own new window, like double-clicking it.
  ///
  /// Only works on Windows.
  /// * [asAdmin]: run it as administrator. Windows asks the user first.
  /// * [wait]: wait for the program to close. Otherwise this returns
  ///   straight away while the program keeps running.
  ///
  /// Returns the program's exit code when [wait] is true, and otherwise 0 if
  /// it opened.
  Future<int> openWindow(
    List<String> args, {
    bool asAdmin = false,
    bool wait = false,
  }) async {
    if (!Platform.isWindows) {
      throw UnsupportedError('openWindow only works on Windows.');
    }

    // PowerShell's Start-Process opens a new window.
    var command = 'Start-Process -FilePath ${_quote(path)}';
    if (workingDirectory != null) {
      command += ' -WorkingDirectory ${_quote(workingDirectory!)}';
    }
    if (args.isNotEmpty) {
      command += ' -ArgumentList ${args.map(_quote).join(',')}';
    }
    if (asAdmin) command += ' -Verb RunAs';
    if (wait) {
      // -PassThru gives back the program, so its exit code can be passed on.
      command = '\$p = $command -Wait -PassThru; exit \$p.ExitCode';
    }

    final result = await Process.run('powershell', [
      '-NoProfile',
      '-Command',
      command,
    ]);

    return result.exitCode;
  }

  /// The full path of the program, or null if it can't be found.
  ///
  /// Looks for the file first, then through your PATH.
  Future<String?> find() async {
    final file = File(path);
    if (file.existsSync()) return file.absolute.path;

    // "where" (Windows) and "which" (Mac and Linux) look through the PATH.
    final finder = Platform.isWindows ? 'where' : 'which';
    final result = await Process.run(finder, [path]);
    if (result.exitCode != 0) return null;

    final found = <String>[];
    for (final line in LineSplitter.split(result.stdout.toString())) {
      if (line.trim().isNotEmpty) found.add(line.trim());
    }
    if (found.isEmpty) return null;

    // On Windows, "where" can also list files Windows can't run, like the
    // "dart" script next to "dart.bat". Pick the first one with an ending
    // such as .exe or .bat.
    if (Platform.isWindows) {
      final endings = (Platform.environment['PATHEXT'] ?? '.EXE;.BAT;.CMD')
          .toLowerCase()
          .split(';');
      for (final file in found) {
        final dot = file.lastIndexOf('.');
        if (dot != -1 && endings.contains(file.substring(dot).toLowerCase())) {
          return file;
        }
      }
    }

    return found.first;
  }

  /// Whether the program can be found, as a file or on your PATH.
  Future<bool> exists() async => await find() != null;

  /// Starts the program with all of its settings and the given [mode].
  Future<Process> _start(List<String> args, ProcessStartMode mode) {
    return Process.start(
      path,
      args,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: inShell,
      mode: mode,
    );
  }

  /// Runs the program to the end, collecting what it prints.
  Future<RunResult> _collect(
    List<String> args, {
    required void Function(String line) onLine,
    required void Function(String line) onErrorLine,
    String? input,
    Duration? timeout,
  }) async {
    final program = await start(args);
    program.onLine = onLine;
    program.onErrorLine = onErrorLine;

    if (input != null) program.write(input);
    await program.closeInput();

    var timedOut = false;
    final int exitCode;
    if (timeout == null) {
      exitCode = await program.wait();
    } else {
      exitCode = await program.wait().timeout(
        timeout,
        onTimeout: () {
          timedOut = true;
          return program.stop();
        },
      );
    }

    return RunResult(
      exitCode: exitCode,
      output: program.output,
      errors: program.errors,
      timedOut: timedOut,
    );
  }

  /// Wraps [text] in single quotes for PowerShell.
  ///
  /// Any single quote inside is doubled, so it stays plain text.
  String _quote(String text) => "'${text.replaceAll("'", "''")}'";
}
