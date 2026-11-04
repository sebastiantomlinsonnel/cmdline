library cmd;

import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

export 'cmd/helpers/process_failed.dart';
export 'cmd/helpers/process_functions.dart';
export 'cmd/helpers/process_helpers.dart';
export 'cmd/helpers/process_result_helpers.dart';
export 'cmd/helpers/stream_helpers.dart';
export 'cmd/helpers/terminal_command.dart';

part 'cmd/draw.dart';

part 'cmd/fs.dart';

part 'cmd/net.dart';

part 'cmd/prompt.dart';

part 'cmd/shell.dart';

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
