import 'dart:io';

import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  final currentPath = Directory.current;
  final Directory api = Directory('${currentPath.path}\\doc\\api');

  if (api.existsSync()) {
    debug('$api exists');
    api.deleteSync(recursive: true);
    debug('Deleted only docs');
  }
  debug('Generating');
  await const ShellCommand('dart doc', show: true, interactive: true).start();
}
