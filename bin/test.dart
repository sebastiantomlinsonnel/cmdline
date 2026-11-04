import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  Logger.instance.showTimestampInOutput = true;

  log('Starting logger');
  await Logger.instance.open(r'X:\Flutter\cmdline\logs\1');
  pass('Log file opened');

  final Stopwatch _clock = Stopwatch()..start();

  for (var i = 0; i < 1000; ++i) {
    dev('TESTING', tag: 'roSe', showTimestamp: true);
  }

  trace(_clock.elapsedMicroseconds);
}

void printAllNames() {
  dev('Finished testing tests', tag: 'roSe');
  log('Building for release');
  debug('Using cache in .dart_tool/build');
  trace('Compiled 42 libraries');
  warn('2 packages have newer versions');
  fail('Could not reach the update server');
  pass('Build finished in 3.2s');
}
