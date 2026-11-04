import 'dart:io';

import 'package:cmdline/cmdline.dart';
import 'package:cmdline/src/demo.dart';

CLI cli = CLI(
  name: 'demo',
  help: 'Features demo',
  flags: [
    const Flag(
      'all',
      short: 'a',
      help: 'Show prompts, menus and other things that need typing',
    ),
    const Flag(
      'hold',
      help: 'Keep the screen still for a few seconds at the end',
      hidden: true,
    ),
  ],
  options: [
    Option(
      'scene',
      short: 'S',
      help: 'Show only this scene of the showcase',
      valueName: 'number',
      allowed: [for (var i = 1; i <= _scenes.length; i++) '$i'],
    ),
  ],
  commands: [
    Command(
      name: 'spinner',
      help: 'A spinner that turns into a PASS line',
      run: (input) => CommandLineDemo.spinnerDemo(),
    ),
    Command(
      name: 'messages',
      help: 'One message of each log level',
      run: (input) => CommandLineDemo.printMessages(),
    ),
    Command(
      name: 'log-file',
      help: 'Saving log messages to a file',
      run: (input) => CommandLineDemo.logFile(),
    ),
    Command(
      name: 'styling',
      help: 'Text styles, colours and the palette',
      run: (input) => CommandLineDemo.styling(),
    ),
    Command(
      name: 'progress',
      help: 'Progress bars',
      run: (input) => CommandLineDemo.progressBar(),
    ),
    Command(
      name: 'theme',
      help: 'Default and custom themes',
      run: (input) => CommandLineDemo.theme(),
    ),
    Command(
      name: 'format',
      help: 'Boxes and tables',
      run: (input) => CommandLineDemo.format(),
    ),
    Command(
      name: 'paths',
      help: 'Joining and splitting paths',
      run: (input) => CommandLineDemo.paths(),
    ),
    Command(
      name: 'files',
      help: 'File helpers, find and showTree',
      run: (input) => CommandLineDemo.files(),
    ),
    Command(
      name: 'shell',
      help: 'Running commands from strings',
      run: (input) => CommandLineDemo.shell(),
    ),
    Command(
      name: 'folder',
      help: 'A cd that carries over to the next command',
      run: (input) => CommandLineDemo.terminalFolder(),
    ),
    Command(
      name: 'processes',
      help: 'Starting, reading and stopping programs',
      run: (input) => CommandLineDemo.processes(),
    ),
    Command(
      name: 'fetch',
      help: 'Download with a progress bar',
      run: (input) => CommandLineDemo.download(),
    ),
    Command(
      name: 'prompts',
      help: 'ask, confirm and the arrow-key menu',
      run: (input) => CommandLineDemo.prompts(),
    ),
    Command(
      name: 'interactive',
      help: 'A shell command that asks for your name',
      run: (input) => CommandLineDemo.interactiveCommand(),
    ),
    Command(
      name: 'to',
      help: 'Show the saved path for a key',
      arguments: [
        const Argument('key', help: 'The saved key, like "c"'),
        const Argument('sub', help: 'A folder inside it', required: false),
      ],
      run: (input) {
        final paths = {'c': r'C:\', 'home': CMD.fs.homeDirectory};
        final path = paths[input.argument('key')];
        if (path == null)
          return fail('No path saved as "${input.argument('key')}".');

        final sub = input.argument('sub');
        log(sub == null ? path : CMD.fs.join(path, sub));
      },
    ),
    Command(
      name: 'open',
      help: 'Open dart.dev in your browser',
      run: (input) => CommandLineDemo.openApp(),
    ),
  ],
  run: (input) async {
    if (input.flag('all')) return CommandLineDemo.demoAll();

    final scene = input.option('scene');
    await _showcase(only: scene == null ? null : int.parse(scene));

    if (input.flag('hold')) await delay(5);
  },
);

final List<(String, Future<void> Function())> _scenes = [
  ('Logging', _logging),
  ('Styling', _styling),
  ('Progress', _progress),
  ('Boxes and tables', _tables),
  ('Files', _files),
  ('Shell commands', _shell),
];

Future<void> _showcase({int? only}) async {
  Logger.instance.verbose = true;
  try {
    if (only != null) {
      final (title, body) = _scenes[only - 1];
      await _scene(only, title, body);

      return;
    }

    await _intro();
    for (var i = 0; i < _scenes.length; i++) {
      final (title, body) = _scenes[i];
      await _scene(i + 1, title, body);
    }
    await _outro();
  } finally {
    stdout.write(SHOW_CURSOR);
  }
}

Future<void> _beat() => delay(0.25);

Future<void> _scene(
  int number,
  String title,
  Future<void> Function() body,
) async {
  final theme = CliTheme.current;
  _clear();
  CliTheme.say('');
  CliTheme.say(
    ' $number/${_scenes.length} '.dim + title.bold.foreground(theme.highlight),
  );
  CliTheme.say(' ${'─' * 40}'.dim.foreground(theme.border));
  CliTheme.say('');
  await delay(0.2);
  await body();
  await delay(1.6);
}

Future<void> _intro() async {
  _clear();
  CliTheme.say('');
  CliTheme.say(
    CMD.draw.box(
      [
        'cmdline'.bold.foreground(AsciiPalette.sky),
        'Friendly command line tools in Dart'.dim,
      ].join('\n'),
    ),
  );
  await delay(1.5);
}

Future<void> _outro() async {
  _clear();
  CliTheme.say('');
  CliTheme.say(
    CMD.draw.box(
      [
        'dart pub add cmdline'.bold.foreground(AsciiPalette.mint),
        'Logging, prompts, styling, files and shell'.dim,
      ].join('\n'),
      title: 'Get started',
    ),
  );
  CliTheme.say('');
  await delay(2);
}

Future<void> _logging() async {
  Logger.instance.startSpinner('Installing dependencies');
  await delay(1.2);
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
  await delay(0.5);
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

  const width = 48;
  const chunk = 6;
  for (var start = 0; start < width; start += chunk) {
    for (var i = start; i < start + chunk; i++) {
      final amount = 1 - i / (width - 1);
      stdout.write(
        ' '.background(
          AsciiPalette.sky.opacity(amount, over: AsciiPalette.rose),
        ),
      );
    }
    await delay(0.05);
  }
  stdout.writeln();
}

Future<void> _progress() async {
  Future<void> fill(ProgressBar bar, int upTo, double seconds) async {
    const frames = 15;
    for (var frame = 1; frame <= frames; frame++) {
      await delay(seconds / frames);
      bar.update((upTo * frame / frames).round());
    }
  }

  final download = ProgressBar(
    'Downloading',
    total: 60,
    colour: AsciiPalette.sky,
  );
  await fill(download, 60, 1);
  download.done('Downloaded 12.4 MB');
  await _beat();

  final compile = ProgressBar(
    'Compiling  ',
    total: 40,
    colour: AsciiPalette.lavender,
  );
  await fill(compile, 40, 0.8);
  compile.done('Compiled 40 files');
  await _beat();

  final upload = ProgressBar(
    'Uploading  ',
    total: 50,
    colour: AsciiPalette.peach,
  );
  await fill(upload, 35, 0.7);
  await delay(0.3);
  upload.failed('Upload stopped at 70%');
}

Future<void> _tables() async {
  final ok = 'up to date'.foreground(AsciiPalette.mint);
  final old = 'update'.foreground(AsciiPalette.butter);
  CliTheme.say(
    CMD.draw.table(
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
  await delay(0.6);
  CliTheme.say(
    CMD.draw.box(
      '${'2'.bold} packages can be updated.\n'
      'Run ${'dart pub upgrade'.foreground(AsciiPalette.sky)} to get them.',
      title: 'Summary',
    ),
  );
}

Future<void> _files() async {
  final temp = Directory.systemTemp.createTempSync('cmdline_gif_').path;
  final app = CMD.fs.join(temp, 'my_app');
  try {
    CMD.fs.join(app, 'pubspec.yaml').write('name: my_app');
    CMD.fs.join(app, 'README.md').write('# my_app');
    CMD.fs.join(app, 'bin', 'my_app.dart').write('void main() {}');
    CMD.fs.joinAll([app, 'lib', 'src', 'app.dart']).write('// app');
    CMD.fs.join(app, 'test', 'app_test.dart').write('// tests');

    CMD.fs.showTree(app);
    await delay(0.6);
    CliTheme.say('');

    final found = await CMD.fs.find('*.dart', workingDirectory: app).toList();
    pass('Found ${found.length} Dart files');
    await _beat();
    for (final file in found) {
      CliTheme.say(
        '  ${CliTheme.current.pointer} ${CMD.fs.basename(file)}'.dim,
      );
      await _beat();
    }
  } finally {
    CMD.fs.deleteDir(temp);
  }
}

Future<void> _shell() async {
  await 'dart --version'.run;
  await _beat();
  await 'git rev-parse --verify no-such-branch'.start(nothrow: true);
}

void _clear() => stdout.write('$CLEAR_SCREEN$CURSOR_HOME$HIDE_CURSOR');

Future<void> main(List<String> args) async => await cli.start(args);
