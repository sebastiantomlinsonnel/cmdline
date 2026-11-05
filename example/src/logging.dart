import 'dart:io';

import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for the logger: levels, log files, spinners and progress bars.
class LoggingDemo {
  const LoggingDemo._();

  /// Runs every logging demo in turn.
  static Future<void> all() async {
    await section('Log levels', messages);
    await section('Log file', logFile);
    await section('Spinners', spinner);
    await section('Progress bars', progress);
  }

  /// Prints one message of each level, with and without tags and timestamps.
  ///
  /// Each level function also gives back the line it printed.
  static void messages() {
    log('Plain log messages look like this');
    trace('Trace: the finest detail');
    debug('Debug: for working out what went wrong');
    warn('Warn: something to look at');
    fail('Fail: something went wrong');
    pass('Pass: something went right');
    dev('Dev: notes to yourself while building');

    heading('Tags');
    log('Messages can carry a tag', tag: 'build');
    warn('Handy when several parts log at once', tag: 'net');

    heading('Timestamps');
    log('This one has a timestamp', showTimestamp: true);
    log('This one does not', showTimestamp: false);

    heading('Building a line without printing it');
    final line = Logger.getString('Built, not printed', Level.debug);
    log('Logger.getString gave back ${line.plain.length} characters');
    write('write() and ');
    writeln('writeln() are plain stdout helpers');
  }

  /// Saves log messages to a file, then shows what the file holds.
  ///
  /// Also shows `onLog`, which sees every line that gets logged.
  static Future<void> logFile() async {
    final dir = tempFolder('cmdline_log_');
    final path = CMD.fs.join(dir, 'demo.log');
    var seen = 0;
    try {
      Logger.instance.open(path, append: false, onLog: (_) => seen++);
      log('This line goes to the screen and to demo.log');
      warn('So does this warning');
      pass('And this pass');
      Logger.instance.close();

      log('onLog saw $seen lines');
      CliTheme.say(
        CMD.draw.box(File(path).readAsStringSync().trim(), title: 'demo.log'),
      );
    } finally {
      Logger.instance.close();
      CMD.fs.deleteDir(dir);
    }
  }

  /// Shows a spinner that ends in a pass, one that ends in a fail, and the
  /// built-in frame sets.
  static Future<void> spinner() async {
    Logger.instance.startSpinner('Installing dependencies');
    await delay(1.5);
    Logger.instance.stopSpinner('Dependencies installed', Level.pass);

    Logger.instance.startSpinner(
      'Reaching the update server',
      level: Level.warn,
      interval: const Duration(milliseconds: 100),
    );
    await delay(1.2);
    Logger.instance.stopSpinner('Update server did not answer', Level.fail);

    heading('Frame sets');
    final sets = {
      'kSPINNER_FRAMES': kSPINNER_FRAMES,
      'kSPINNER_LINE': kSPINNER_LINE,
      'kSPINNER_ARC': kSPINNER_ARC,
      'kSPINNER_CIRCLE': kSPINNER_CIRCLE,
      'kSPINNER_BOUNCE': kSPINNER_BOUNCE,
    };
    CliTheme.say(
      CMD.draw.table(
        [
          for (final entry in sets.entries) [entry.key, entry.value.join(' ')],
        ],
        header: ['Name', 'Frames'],
      ),
    );
  }

  /// Fills a few progress bars, including one that fails.
  static Future<void> progress() async {
    final copy = ProgressBar('Copying files', total: 40);
    for (var i = 0; i < 40; i++) {
      await delay(0.03);
      copy.add();
    }
    copy.done('Copied 40 files');

    final download = ProgressBar(
      'Downloading',
      total: 100,
      width: 40,
      colour: AnsiPalette.sky,
    );
    for (var i = 0; i <= 100; i += 5) {
      await delay(0.04);
      download.update(i);
    }
    download.done('Downloaded 12.4 MB');

    final upload = ProgressBar(
      'Uploading',
      total: 10,
      colour: AnsiPalette.peach,
    );
    for (var i = 0; i < 6; i++) {
      await delay(0.05);
      upload.add();
    }
    upload.failed('Upload stopped at ${(upload.fraction * 100).round()}%');

    heading('Just the bar');
    for (final fraction in [0.0, 0.33, 0.5, 0.875, 1.0]) {
      CliTheme.say(
        '${ProgressBar.bar(fraction, width: 20, colour: AnsiPalette.lavender)} '
            '$fraction',
      );
    }
  }
}
