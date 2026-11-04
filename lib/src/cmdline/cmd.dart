import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

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
