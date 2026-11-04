library cmd;

import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

export 'helpers/process_failed.dart';
export 'helpers/process_functions.dart';
export 'helpers/process_helpers.dart';
export 'helpers/process_result_helpers.dart';
export 'helpers/stream_helpers.dart';
export 'helpers/terminal_command.dart';
export 'types/extensions.dart';
export 'types/file_error.dart';

part 'draw.dart';
part 'fs.dart';
part 'net.dart';
part 'prompt.dart';
part 'shell.dart';

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

  /// Shell helpers
  static _Shell get shell => const _Shell._();

  const CMD._();
}

/// A delayed future of however many seconds
Future<void> delay(double seconds) async {
  final int _seconds = seconds.floor();
  final int _milliseconds = ((seconds - _seconds) * 1000).ceil();
  return Future.delayed(
    Duration(milliseconds: _milliseconds, seconds: _seconds),
  );
}
