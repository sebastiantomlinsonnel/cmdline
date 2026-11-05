/// Shell helpers
library cmd;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

export 'src/cmd/helpers/process_failed.dart';
export 'src/cmd/shell_command.dart';
export 'src/cmd/types/file_error.dart';

part 'src/cmd/parts/draw.dart';

part 'src/cmd/parts/fs.dart';

part 'src/cmd/parts/net.dart';

part 'src/cmd/parts/prompt.dart';

/// CMDLine helpers
class CMD {
  /// Filesystem helpers
  static _FS get fs => const _FS._();

  /// Ansi drawing helpers
  static _Draw get draw => const _Draw._();

  /// Network helpers
  static _Net get net => const _Net._();

  /// Terminal prompts
  static _Prompt get prompt => const _Prompt._();

  const CMD._();

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
  static Future<bool> isPrivilegedUser() async {
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
  static Future<int> withPrivileges(List<String> arguments) async {
    if (await isPrivilegedUser()) return 0;

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

  /// The full path of a program on your PATH, or null if it can't be found.
  ///
  /// [name] can also be a file path; then its full path is given back if the
  /// file exists.
  ///
  /// ```dart
  /// if (await findProgram('docker') == null) warn('Docker is not installed');
  /// ```
  static Future<String?> findProgram(String name) async {
    final file = File(name);
    if (file.existsSync()) return file.absolute.path;

    // "where" (Windows) and "which" (Mac and Linux) look through the PATH.
    final finder = Platform.isWindows ? 'where' : 'which';
    final result = await Process.run(finder, [name]);
    if (result.exitCode != 0) return null;

    final found = <String>[];
    for (final line in LineSplitter.split(result.stdout.toString())) {
      if (line
          .trim()
          .isNotEmpty) found.add(line.trim());
    }
    if (found.isEmpty) return null;

    // On Windows, "where" can also list files Windows can't run, like the
    // "dart" script next to "dart.bat". Pick the first one with an ending
    // such as .exe or .bat.
    if (Platform.isWindows) {
      final endings = (Platform.environment['PATHEXT'] ?? '.EXE;.BAT;.CMD')
          .toLowerCase()
          .split(';');
      for (final path in found) {
        final dot = path.lastIndexOf('.');
        if (dot != -1 && endings.contains(path.substring(dot).toLowerCase())) {
          return path;
        }
      }
    }

    return found.first;
  }

  /// The path of a file in the same folder as the running script.
  ///
  /// Handy for tools you ship next to your code, like `bin/speedtest.exe`.
  /// If the file isn't there, [fileName] is given back as it is, so
  /// `Process.start` tries your PATH instead.
  ///
  /// ```dart
  /// await Process.start(nextToScript('speedtest.exe'), []);
  /// ```
  static String nextToScript(String fileName) {
    final file = File.fromUri(Platform.script.resolve(fileName));
    if (file.existsSync()) return file.path;

    return fileName;
  }

  /// Opens [program] in its own new window, like double-clicking it.
  ///
  /// Only works on Windows.
  /// * [args]: the arguments for the program.
  /// * [workingDirectory]: the folder it runs in.
  /// * [asAdmin]: run it as administrator. Windows asks the user first.
  /// * [wait]: wait for the program to close. Otherwise this returns straight
  ///   away while the program keeps running.
  ///
  /// Returns the program's exit code when [wait] is true, and otherwise 0 if
  /// it opened.
  static Future<int> openInNewWindow(String program, {
    List<String> args = const [],
    String? workingDirectory,
    bool asAdmin = false,
    bool wait = false,
  }) async {
    if (!Platform.isWindows) {
      throw UnsupportedError('openInNewWindow only works on Windows.');
    }

    // PowerShell's Start-Process opens a new window.
    var command = 'Start-Process -FilePath ${quoteWrap(program)}';
    if (workingDirectory != null) {
      command += ' -WorkingDirectory ${quoteWrap(workingDirectory)}';
    }
    if (args.isNotEmpty) {
      command += ' -ArgumentList ${args.map(quoteWrap).join(',')}';
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

  /// Opens a file, folder or web address with its usual app.
  ///
  /// Like double-clicking it: a `.txt` file opens in your text editor and a
  /// web address opens in your browser.
  static Future<void> openWithDefaultApp(String target) async {
    if (Platform.isWindows) {
      await Process.run('powershell', [
        '-NoProfile',
        '-Command',
        'Start-Process ${quoteWrap(target)}',
      ]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [target]);
    } else {
      await Process.run('xdg-open', [target]);
    }
  }

  /// Wraps [text] in single quotes for PowerShell.
  ///
  /// Any single quote inside is doubled, so it stays plain text.
  static String quoteWrap(String text) => "'${text.replaceAll("'", "''")}'";
}

/// A delayed future of however many seconds
Future<void> delay(double seconds) async {
  final int _seconds = seconds.floor();
  final int _milliseconds = ((seconds - _seconds) * 1000).ceil();
  return Future.delayed(
    Duration(milliseconds: _milliseconds, seconds: _seconds),
  );
}
