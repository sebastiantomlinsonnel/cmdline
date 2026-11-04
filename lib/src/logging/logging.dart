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
String dev(Object? message, {String? tag, bool? showTimestamp}) {
  final String _message = Logger.getString(
    message,
    Level.dev,
    showTimestamp: showTimestamp,
    tag: tag,
  );
  Logger.print('$_message');
  return _message;
}

/// Prints a trace message to stdout and saves it to the log file if one is open
String trace(Object? message) {
  final String _message = Logger.getString(message, Level.trace);
  Logger.print('$_message');
  return _message;
}

/// Prints a debug message to stdout and saves it to the log file if one is open
String debug(Object? message) {
  final String _message = Logger.getString(message, Level.debug);
  Logger.print('$_message');
  return _message;
}

/// Prints a fail message to stdout and saves it to the log file if one is open
String fail(Object? message) {
  final String _message = Logger.getString(message, Level.fail);
  Logger.print('$_message');
  return _message;
}

/// Prints a pass message to stdout and saves it to the log file if one is open
String pass(Object? message) {
  final String _message = Logger.getString(message, Level.pass);
  Logger.print('$_message');
  return _message;
}

/// Prints a warn message to stdout and saves it to the log file if one is open
String warn(Object? message) {
  final String _message = Logger.getString(message, Level.warn);
  Logger.print('$_message');
  return _message;
}

/// Prints a log message to stdout and saves it to the log file if one is open
String log(Object? message) {
  final String _message = Logger.getString(message, Level.log);
  Logger.print('$_message');
  return _message;
}
