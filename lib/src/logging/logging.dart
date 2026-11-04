library logging;

import 'dart:io';

import 'package:cmdline/cmdline.dart';

export 'frames.dart';
export 'level.dart';
export 'logger.dart';
export 'logging.dart';
export 'progress_bar.dart';

/// stdout.write
String write(Object? data) {
  final String _data = data.toString();
  stdout.write(_data);
  return _data;
}

/// stdout.writeln
String writeln(Object? data) {
  final String _data = data.toString();
  stdout.writeln(_data);
  return _data;
}

/// Prints a dev message to stdout and saves it to the log file if one is open
String dev(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.dev, tag, showTimestamp);

/// Prints a trace message to stdout and saves it to the log file if one is open
String trace(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.trace, tag, showTimestamp);

/// Prints a debug message to stdout and saves it to the log file if one is open
String debug(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.debug, tag, showTimestamp);

/// Prints a fail message to stdout and saves it to the log file if one is open
String fail(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.fail, tag, showTimestamp);

/// Prints a pass message to stdout and saves it to the log file if one is open
String pass(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.pass, tag, showTimestamp);

/// Prints a warn message to stdout and saves it to the log file if one is open
String warn(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.warn, tag, showTimestamp);

/// Prints a log message to stdout and saves it to the log file if one is open
String log(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.log, tag, showTimestamp);

String _print(Object? message, Level level, String? tag, bool? showTimestamp) {
  final String _message = Logger.getString(
    message,
    level,
    showTimestamp: showTimestamp,
    tag: tag,
  );
  Logger.print('$_message');
  return _message;
}
