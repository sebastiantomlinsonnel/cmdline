import 'dart:io';

import 'package:cmdline/cmdline.dart';

Future<void> main(List<String> args) async {
  final currentPath = Directory.current;
  final Directory api = Directory('${currentPath.path}\\doc\\api');

  if (args.firstOrNull != null && args.first == 'r' && api.existsSync()) {
    debug('$api exists');
    api.deleteSync(recursive: true);
    debug('Deleted only api docs');
  }

  debug('Generating');
  await const ShellCommand('dart doc', show: true, interactive: true).start();
}
