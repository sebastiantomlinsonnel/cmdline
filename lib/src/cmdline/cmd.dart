import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

part 'cmd/draw.dart';
part 'cmd/fs.dart';
part 'cmd/net.dart';
part 'cmd/prompt.dart';
part 'cmd/shell.dart';

class CMD {
  static FS get fs => const FS._();

  static Draw get draw => const Draw._();

  static Net get net => const Net._();

  static Prompt get prompt => const Prompt._();

  static Shell get shell => const Shell._();

  const CMD._();
}
