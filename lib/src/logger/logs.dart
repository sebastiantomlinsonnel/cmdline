import 'package:cmdline/cmdline.dart';

String getDev(dynamic message) =>
    Logger.instance.getString('$message', Level.dev);

String getTrace(dynamic message) =>
    Logger.instance.getString('$message', Level.trace);

String getDebug(dynamic message) =>
    Logger.instance.getString('$message', Level.debug);

String getFail(dynamic message) =>
    Logger.instance.getString('$message', Level.fail);

String getPass(dynamic message) =>
    Logger.instance.getString('$message', Level.pass);

String getWarn(dynamic message) =>
    Logger.instance.getString('$message', Level.warn);

String getLog(dynamic message) =>
    Logger.instance.getString('$message', Level.log);
