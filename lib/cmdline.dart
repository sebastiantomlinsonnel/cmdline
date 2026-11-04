// ignore_for_file: public_member_api_docs

library;

import 'dart:io';

import 'cmdline.dart';

export 'src/ansi.dart';
export 'src/cli.dart';
export 'src/cmd.dart';
export 'src/logger.dart';

String write(dynamic data) {
  stdout.write(data);
  return data.toString();
}

String writeln(dynamic data) {
  stdout.writeln(data);
  return data.toString();
}

void dev(dynamic message) => Logger.print('$message', Level.dev);

void trace(dynamic message) => Logger.print('$message', Level.trace);

void debug(dynamic message) => Logger.print('$message', Level.debug);

void fail(dynamic message) => Logger.print('$message', Level.fail);

void pass(dynamic message) => Logger.print('$message', Level.pass);

void warn(dynamic message) => Logger.print('$message', Level.warn);

void log(dynamic message) => Logger.print('$message', Level.log);

Future<void> delay(double seconds) async {
  final int _seconds = seconds.floor();
  final int _milliseconds = ((seconds - _seconds) * 1000).ceil();
  return Future.delayed(
    Duration(milliseconds: _milliseconds, seconds: _seconds),
  );
}

String getDev(dynamic message) => Logger.getString('$message', Level.dev);

String getTrace(dynamic message) => Logger.getString('$message', Level.trace);

String getDebug(dynamic message) => Logger.getString('$message', Level.debug);

String getFail(dynamic message) => Logger.getString('$message', Level.fail);

String getPass(dynamic message) => Logger.getString('$message', Level.pass);

String getWarn(dynamic message) => Logger.getString('$message', Level.warn);

String getLog(dynamic message) => Logger.getString('$message', Level.log);
