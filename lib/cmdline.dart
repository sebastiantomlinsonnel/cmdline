library;

import 'cmdline.dart';

export 'src/ascii/ascii.dart';
export 'src/ascii/constants/characters.dart';
export 'src/ascii/constants/colours.dart';
export 'src/ascii/constants/colours_16.dart';
export 'src/ascii/constants/controls.dart';
export 'src/ascii/constants/cursor.dart';
export 'src/ascii/constants/screen.dart';
export 'src/ascii/constants/styling.dart';
export 'src/ascii/constants/terminal.dart';
export 'src/ascii/extensions/ascii_styled_string.dart';
export 'src/ascii/palettes/ascii_colour.dart';
export 'src/ascii/palettes/ascii_colour_rgb.dart';
export 'src/ascii/palettes/ascii_ink.dart';
export 'src/ascii/utils/ascii_printer.dart';
export 'src/cli/cli.dart';
export 'src/cli/commands/cli_error.dart';
export 'src/cli/parser/command.dart';
export 'src/cli/parser/flag.dart';
export 'src/cli/commands/help.dart';
export 'src/cli/parser/input.dart';
export 'src/cli/parser/option.dart';
export 'src/cli/parser/parser.dart';
export 'src/cmdline/demo.dart';
export 'src/cmdline/helpers/process_failed.dart';
export 'src/cmdline/helpers/process_functions.dart';
export 'src/cmdline/helpers/process_helpers.dart';
export 'src/cmdline/helpers/process_result_helpers.dart';
export 'src/cmdline/helpers/stream_helpers.dart';
export 'src/cmdline/helpers/terminal_command.dart';
export 'src/logger/constants/frames.dart';
export 'src/logger/dev_type.dart';
export 'src/logger/logger.dart';
export 'src/logger/logs.dart';
export 'src/logger/progress_bar.dart';

void dev(dynamic message) => Logger.print('$message', Level.dev);

void trace(dynamic message) => Logger.print('$message', Level.trace);

void debug(dynamic message) => Logger.print('$message', Level.debug);

void fail(dynamic message) => Logger.print('$message', Level.fail);

void pass(dynamic message) => Logger.print('$message', Level.pass);

void warn(dynamic message) => Logger.print('$message', Level.warn);

void log(dynamic message) => Logger.print('$message', Level.log);

Future<void> delay(double seconds) async {
  int _seconds = seconds.floor();
  int _milliseconds = ((seconds - _seconds) * 1000).ceil();
  return Future.delayed(
    Duration(milliseconds: _milliseconds, seconds: _seconds),
  );
}
