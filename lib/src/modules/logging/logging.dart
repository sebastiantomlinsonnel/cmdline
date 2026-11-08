/// A ultrafast, versatile, easy to use logging system.
///
/// {@category logging}
library logging;

import 'dart:io';

import 'package:cmdline/cmdline.dart';

export 'frames.dart';
export 'level.dart';
export 'logger.dart';
export 'progress_bar.dart';

/// {@category logging}
String write(Object? data) {
  final String _data = data.toString();
  stdout.write(_data);
  return _data;
}

/// {@category logging}
String writeln(Object? data) {
  final String _data = data.toString();
  stdout.writeln(_data);
  return _data;
}

/// {@category logging}
String dev(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.dev, tag, showTimestamp);

/// {@category logging}
String trace(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.trace, tag, showTimestamp);

/// {@category logging}
String debug(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.debug, tag, showTimestamp);

/// {@category logging}
String fail(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.fail, tag, showTimestamp);

/// {@category logging}
String pass(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.pass, tag, showTimestamp);

/// {@category logging}
String warn(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.warn, tag, showTimestamp);

/// {@category logging}
String log(Object? message, {String? tag, bool? showTimestamp}) =>
    _print(message, Level.log, tag, showTimestamp);

/// {@category logging}
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
