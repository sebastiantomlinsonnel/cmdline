import 'dart:io';

import 'package:cmdline/cmdline.dart';

CLI cli = CLI(
  name: 'demo',
  about: 'Features demo',
  flags: [
    const Flag(
      'all',
      short: 'a',
      help: 'Show prompts, menus and other things that need typing',
    ),
  ],
  commands: [
    Command(
      name: 'spinner',
      about: 'A spinner that turns into a PASS line',
      run: (input) => CommandLineDemo.spinnerDemo(),
    ),
    Command(
      name: 'messages',
      about: 'One message of each log level',
      run: (input) => CommandLineDemo.printMessages(),
    ),
    Command(
      name: 'log-file',
      about: 'Saving log messages to a file',
      run: (input) => CommandLineDemo.logFile(),
    ),
    Command(
      name: 'styling',
      about: 'Text styles, colours and the palette',
      run: (input) => CommandLineDemo.styling(),
    ),
    Command(
      name: 'progress',
      about: 'Progress bars',
      run: (input) => CommandLineDemo.progressBar(),
    ),
    Command(
      name: 'theme',
      about: 'Default and custom themes',
      run: (input) => CommandLineDemo.theme(),
    ),
    Command(
      name: 'format',
      about: 'Boxes and tables',
      run: (input) => CommandLineDemo.format(),
    ),
    Command(
      name: 'paths',
      about: 'Joining and splitting paths',
      run: (input) => CommandLineDemo.paths(),
    ),
    Command(
      name: 'files',
      about: 'File helpers, find and showTree',
      run: (input) => CommandLineDemo.files(),
    ),
    Command(
      name: 'env',
      about: 'Variables, PATH and which',
      run: (input) => CommandLineDemo.environment(),
    ),
    Command(
      name: 'shell',
      about: 'Running commands from strings',
      run: (input) => CommandLineDemo.shell(),
    ),
    Command(
      name: 'folder',
      about: 'A cd that carries over to the next command',
      run: (input) => CommandLineDemo.terminalFolder(),
    ),
    Command(
      name: 'processes',
      about: 'Starting, reading and stopping programs',
      run: (input) => CommandLineDemo.processes(),
    ),
    Command(
      name: 'fetch',
      about: 'Download with a progress bar',
      run: (input) => CommandLineDemo.download(),
    ),
    Command(
      name: 'prompts',
      about: 'ask, confirm and the arrow-key menu',
      run: (input) => CommandLineDemo.prompts(),
    ),
    Command(
      name: 'interactive',
      about: 'A shell command that asks for your name',
      run: (input) => CommandLineDemo.interactiveCommand(),
    ),
    Command(
      name: 'open',
      about: 'Open dart.dev in your browser',
      run: (input) => CommandLineDemo.openApp(),
    ),
  ],
  run: (input) {
    if (input.flag('all')) {
      return CommandLineDemo.demoAll();
    } else {
      return showcase();
    }
  },
);

Future<void> main(List<String> args) async => await cli.start(args);

/// How many scenes [showcase] has, for the "1/6" counter.
const _sceneCount = 6;

/// A short, paced tour of the package, made for recording a GIF.
///
/// Each scene starts on a clear screen with a numbered heading, and pauses
/// at the end so viewers can read it. Nothing personal (like your PATH or
/// home folder) is shown. The longest line is `dart --version`, so a 90-column
/// terminal fits everything.
Future<void> showcase() async {
  // Show debug and trace lines, even without --verbose.
  Logger.instance.verbose = true;
  try {
    await _intro();
    await _scene(1, 'Logging', _logging);
    await _scene(2, 'Styling', _styling);
    await _scene(3, 'Progress', _progress);
    await _scene(4, 'Boxes and tables', _tables);
    await _scene(5, 'Files', _files);
    await _scene(6, 'Shell commands', _shell);
    await _outro();
  } finally {
    stdout.write(SHOW_CURSOR);
  }
}

/// Clears the screen and hides the cursor, ready for the next scene.
void _clear() => stdout.write('$CLEAR_SCREEN$CURSOR_HOME$HIDE_CURSOR');

/// A short pause between lines, so they appear one at a time.
Future<void> _beat() => delay(0.35);

/// Shows one numbered scene, then pauses so it can be read.
Future<void> _scene(
  int number,
  String title,
  Future<void> Function() body,
) async {
  final theme = CliTheme.current;
  _clear();
  CliTheme.say('');
  CliTheme.say(
    ' $number/$_sceneCount '.dim + title.bold.foreground(theme.highlight),
  );
  CliTheme.say(' ${'─' * 40}'.dim.foreground(theme.border));
  CliTheme.say('');
  await delay(0.5);
  await body();
  await delay(2.5);
}

/// A title card with the package name.
Future<void> _intro() async {
  _clear();
  CliTheme.say('');
  CliTheme.say(
    box(
      [
        'cmdline'.bold.foreground(AsciiPalette.sky),
        'Friendly command line tools in Dart'.dim,
      ].join('\n'),
    ),
  );
  await delay(2);
}

/// Points viewers at how to get the package.
Future<void> _outro() async {
  _clear();
  CliTheme.say('');
  CliTheme.say(
    box(
      [
        'dart pub add cmdline'.bold.foreground(AsciiPalette.mint),
        'Logging, prompts, styling, files and shell'.dim,
      ].join('\n'),
      title: 'Get started',
    ),
  );
  CliTheme.say('');
  await delay(3);
}

/// A spinner, then one message of each log level.
Future<void> _logging() async {
  Logger.instance.startSpinner('Installing dependencies');
  await delay(1.8);
  Logger.instance.stopSpinner('Dependencies installed', Level.pass);
  await _beat();

  log('Building for release');
  await _beat();
  debug('Using cache in .dart_tool/build');
  await _beat();
  trace('Compiled 42 libraries');
  await _beat();
  warn('2 packages have newer versions');
  await _beat();
  fail('Could not reach the update server');
  await _beat();
  pass('Build finished in 3.2s');
}

/// Text styles, the colour palette and a blended gradient.
Future<void> _styling() async {
  CliTheme.say(
    [
      'bold'.bold,
      'dim'.dim,
      'italic'.italic,
      'underline'.underline,
      'curly'.curlyUnderline.underlineColour(AsciiPalette.rose),
      'strike'.strikethrough,
      'inverse'.inverse,
    ].join('  '),
  );
  await delay(0.8);
  CliTheme.say('');

  final palette = {
    'orchid': AsciiPalette.orchid,
    'mint': AsciiPalette.mint,
    'sky': AsciiPalette.sky,
    'lavender': AsciiPalette.lavender,
    'rose': AsciiPalette.rose,
    'peach': AsciiPalette.peach,
    'butter': AsciiPalette.butter,
    'aqua': AsciiPalette.aqua,
  };
  final names = palette.keys.toList();
  for (var row = 0; row < names.length; row += 4) {
    final cells = [
      for (final name in names.skip(row).take(4))
        '${'██'.foreground(palette[name]!)} ${name.padRight(9)}',
    ];
    CliTheme.say(cells.join(' '));
    await _beat();
  }
  CliTheme.say('');

  // Fade from sky to rose, one cell at a time.
  const width = 48;
  for (var i = 0; i < width; i++) {
    final amount = 1 - i / (width - 1);
    stdout.write(
      ' '.background(AsciiPalette.sky.opacity(amount, over: AsciiPalette.rose)),
    );
    await delay(0.015);
  }
  stdout.writeln();
}

/// Three progress bars: two finish and one fails.
Future<void> _progress() async {
  Future<void> fill(ProgressBar bar, int upTo, double seconds) async {
    for (var i = 0; i < upTo; i++) {
      await delay(seconds / upTo);
      bar.add();
    }
  }

  final download = ProgressBar(
    'Downloading',
    total: 60,
    colour: AsciiPalette.sky,
  );
  await fill(download, 60, 1.5);
  download.done('Downloaded 12.4 MB');
  await _beat();

  final compile = ProgressBar(
    'Compiling  ',
    total: 40,
    colour: AsciiPalette.lavender,
  );
  await fill(compile, 40, 1.2);
  compile.done('Compiled 40 files');
  await _beat();

  final upload = ProgressBar(
    'Uploading  ',
    total: 50,
    colour: AsciiPalette.peach,
  );
  await fill(upload, 35, 1);
  await delay(0.4);
  upload.failed('Upload stopped at 70%');
}

/// A table with styled cells, and a summary box.
Future<void> _tables() async {
  final ok = 'up to date'.foreground(AsciiPalette.mint);
  final old = 'update'.foreground(AsciiPalette.butter);
  CliTheme.say(
    table(
      [
        ['args', '2.7.0', ok],
        ['http', '1.2.2', old],
        ['path', '1.9.1', ok],
        ['yaml', '3.1.2', old],
      ],
      header: ['Package', 'Version', 'Status'],
      rightAligned: {1},
    ),
  );
  await delay(1);
  CliTheme.say(
    box(
      '${'2'.bold} packages can be updated.\n'
      'Run ${'dart pub upgrade'.foreground(AsciiPalette.sky)} to get them.',
      title: 'Summary',
    ),
  );
}

/// Builds a small project, shows it as a tree and searches it.
Future<void> _files() async {
  final temp = Directory.systemTemp.createTempSync('cmdline_gif_').path;
  final app = join(temp, 'my_app');
  try {
    join(app, 'pubspec.yaml').write('name: my_app');
    join(app, 'README.md').write('# my_app');
    join(app, 'bin', 'my_app.dart').write('void main() {}');
    joinAll([app, 'lib', 'src', 'app.dart']).write('// app');
    join(app, 'test', 'app_test.dart').write('// tests');

    showTree(app);
    await delay(1);
    CliTheme.say('');

    final found = await find('*.dart', workingDirectory: app).toList();
    pass('Found ${found.length} Dart files');
    await _beat();
    for (final file in found) {
      CliTheme.say('  ${CliTheme.current.pointer} ${basename(file)}'.dim);
      await _beat();
    }
  } finally {
    deleteDir(temp);
  }
}

/// Runs commands from strings, including one that fails.
Future<void> _shell() async {
  // Verbose mode shows each command before it runs.
  await 'dart --version'.run;
  await _beat();
  await 'git --version'.run;
  await _beat();
  await 'git rev-parse --verify no-such-branch'.start(nothrow: true);
}
