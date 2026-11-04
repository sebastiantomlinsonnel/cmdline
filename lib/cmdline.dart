library;

import 'dart:io';

import 'cmdline.dart';

export 'src/ansi.dart';
export 'src/cli.dart';
export 'src/cmd.dart';
export 'src/logger.dart';

/// stdout.write
String write(dynamic data) {
  final String _data = data.toString();
  stdout.write(_data);
  return _data;
}

/// stdout.writeln
String writeln(dynamic data) {
  final String _data = data.toString();
  stdout.writeln(_data);
  return _data;
}

/// Black on White background
String dev(dynamic message) {
  final String _message = Logger.getString(message, Level.dev);
  Logger.print('$_message');
  return _message;
}

/// Magenta
String trace(dynamic message) {
  final String _message = Logger.getString(message, Level.trace);
  Logger.print('$_message');
  return _message;
}

/// Green
String debug(dynamic message) {
  final String _message = Logger.getString(message, Level.debug);
  Logger.print('$_message');
  return _message;
}

/// Red
String fail(dynamic message) {
  final String _message = Logger.getString(message, Level.fail);
  Logger.print('$_message');
  return _message;
}

/// Green
String pass(dynamic message) {
  final String _message = Logger.getString(message, Level.pass);
  Logger.print('$_message');
  return _message;
}

/// Orange
String warn(dynamic message) {
  final String _message = Logger.getString(message, Level.warn);
  Logger.print('$_message');
  return _message;
}

/// White
String log(dynamic message) {
  final String _message = Logger.getString(message, Level.log);
  Logger.print('$_message');
  return _message;
}
