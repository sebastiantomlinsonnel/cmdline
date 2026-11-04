import 'package:cmdline/cmdline.dart';

const String LOG_FILE = r'X:\Flutter\cmdline\log';

Future<void> main() async {
  await openLogFile();
  printAllNames();
  stressTest(false);
}

void stressTest(bool clear) {
  final Stopwatch _clock = Stopwatch()..start();
  for (var i = 0; i < 1000; ++i) {
    printAllNames();
  }
  _clock.stop();

  if (clear) write('$CLEAR');
  trace(
    'Stress test.bat took ${_clock.elapsedMicroseconds}μs|${_clock.elapsedMilliseconds}ms',
  );
}

Future<void> openLogFile() async {
  CMD.fs.tryDeleteFile(LOG_FILE);
  await Logger.instance.open(LOG_FILE);
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
