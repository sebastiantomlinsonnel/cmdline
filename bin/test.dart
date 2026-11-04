import 'package:cmdline/cmdline.dart';

const String LOG_FILE = r'X:\Flutter\cmdline\log';

Future<void> main() async {
  const String string = 'abcdefg';
  final List<String> letters = string.split('');
  trace(letters);

  // await openLogFile();
  // printAllNames();
  // stressTest(true);
}

void stressTest(bool clear) {
  final Stopwatch _clock = Stopwatch()..start();
  for (var i = 0; i < 1000; ++i) {
    printAllNames();
  }
  _clock.stop();
  // if (clear) write('$CLEAR_SCREEN$CLEAR_LINE${cursorTo(0, 0)}');
  if (clear) write('$CLEAR');
  trace(
    'Stress test took ${_clock.elapsedMicroseconds}μs|${_clock.elapsedMilliseconds}ms',
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
