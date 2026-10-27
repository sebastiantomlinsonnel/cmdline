library;

import 'cmdline.dart';

export 'src/ascii/ascii.dart';
export 'src/ascii/constants/colours.dart';
export 'src/ascii/constants/controls.dart';
export 'src/ascii/constants/styling.dart';
export 'src/ascii/extensions/ascii_styled_string.dart';
export 'src/ascii/palettes/ascii_colour.dart';
export 'src/ascii/palettes/ascii_colour_rgb.dart';
export 'src/ascii/palettes/ascii_ink.dart';
export 'src/ascii/utils/ascii_printer.dart';
export 'src/cmdline/cmdline.dart';
export 'src/cmdline/demo.dart';
export 'src/logger/dev_type.dart';
export 'src/logger/logger.dart';
export 'src/logger/logs.dart';

void dev(dynamic message) => Logger.print('$message', Level.dev);

void trace(dynamic message) => Logger.print('$message', Level.trace);

void debug(dynamic message) => Logger.print('$message', Level.debug);

void fail(dynamic message) => Logger.print('$message', Level.fail);

void pass(dynamic message) => Logger.print('$message', Level.pass);

void warn(dynamic message) => Logger.print('$message', Level.warn);

void log(dynamic message) => Logger.print('$message', Level.log);
