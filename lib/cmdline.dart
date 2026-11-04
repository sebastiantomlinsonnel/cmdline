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
  dev('Starting logger', showTimestamp: true);
  Logger.instance.showTimestampInOutput = true;
  dev('Started logger');

  for (var i = 0; i < 100; ++i) {
    dev('TESTING', tag: 'roSe');
  }
  dev('Finished testing tests', tag: 'roSe');

  log('Building for release');
  debug('Using cache in .dart_tool/build');
  trace('Compiled 42 libraries');
  warn('2 packages have newer versions');
  fail('Could not reach the update server');
  pass('Build finished in 3.2s');
}
