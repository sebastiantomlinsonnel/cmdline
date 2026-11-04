library cmd;

import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

export 'helpers/process_failed.dart';
export 'helpers/process_functions.dart';
export 'helpers/process_result_helpers.dart';
export 'helpers/stream_helpers.dart';
export 'terminal_command.dart';
export 'types/extensions.dart';
export 'types/file_error.dart';

part 'parts/draw.dart';

part 'parts/fs.dart';

part 'parts/net.dart';

part 'parts/prompt.dart';

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
}

/// A delayed future of however many seconds
Future<void> delay(double seconds) async {
  final int _seconds = seconds.floor();
  final int _milliseconds = ((seconds - _seconds) * 1000).ceil();
  return Future.delayed(
    Duration(milliseconds: _milliseconds, seconds: _seconds),
  );
}
