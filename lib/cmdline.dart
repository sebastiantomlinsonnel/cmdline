library;

import 'dart:io';

import 'cmdline.dart';

export 'src/ansi.dart';
export 'src/cli.dart';
export 'src/cmd.dart';
export 'src/logger.dart';

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

/// Black on White background
String dev(Object? message) {
  final String _message = Logger.getString(message, Level.dev);
  Logger.print('$_message');
  return _message;
}

/// Magenta
String trace(Object? message) {
  final String _message = Logger.getString(message, Level.trace);
  Logger.print('$_message');
  return _message;
}

/// Green
String debug(Object? message) {
  final String _message = Logger.getString(message, Level.debug);
  Logger.print('$_message');
  return _message;
}

/// Red
String fail(Object? message) {
  final String _message = Logger.getString(message, Level.fail);
  Logger.print('$_message');
  return _message;
}

/// Green
String pass(Object? message) {
  final String _message = Logger.getString(message, Level.pass);
  Logger.print('$_message');
  return _message;
}

/// Orange
String warn(Object? message) {
  final String _message = Logger.getString(message, Level.warn);
  Logger.print('$_message');
  return _message;
}

/// White
String log(Object? message) {
  final String _message = Logger.getString(message, Level.log);
  Logger.print('$_message');
  return _message;
}

Future<void> main() async {
  await Logger.instance.logFile?.flush();
}
