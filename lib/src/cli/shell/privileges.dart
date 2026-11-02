import 'dart:io';

import 'package:cmdline/cmdline.dart';

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
Future<bool> get isPrivilegedUser async => _privileged ??= await _check();

bool? _privileged;

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
      workingDirectory: pwd,
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
