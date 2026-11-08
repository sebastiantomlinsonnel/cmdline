/// A tour of everything in package:cmdline.
///
/// Run it with no arguments for the short showcase (the README GIFs), or pick a
/// part:
///
///   dart run example/main.dart --help
///   dart run example/main.dart logging messages
///   dart run example/main.dart cmd files
///   dart run example/main.dart --all          (every demo, including prompts)
///
/// The demos live in example/src, one file per area.
import 'dart:io';

import 'package:cmdline/cmdline.dart';

import 'src/ansi.dart';
import 'src/cli.dart';
import 'src/cmd.dart';
import 'src/logging.dart';
import 'src/section.dart';
import 'src/utils.dart';

/// The demo program, built with the package's own CLI builder.
///
/// Groups without a `run` (like `logging` or `cmd`) print their help screen,
/// so `demo cmd` lists every CMD demo.
final CLI cli = CLI(
  name: 'demo',
  help: 'A tour of everything in package:cmdline',
  version: '2.0.0',
  flags: [
    const Flag(
      'all',
      short: 'a',
      help: 'Run every demo, including the ones that ask you things',
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
      name: 'logging',
      help: 'Log levels, log files, spinners and progress bars',
      commands: [
        Command(
          name: 'messages',
          help: 'One message of each level, tags and timestamps',
          run: (_) => LoggingDemo.messages(),
        ),
        Command(
          name: 'log-file',
          help: 'Saving log messages to a file',
          run: (_) => LoggingDemo.logFile(),
        ),
        Command(
          name: 'spinner',
          help: 'Spinners and their frame sets',
          run: (_) => LoggingDemo.spinner(),
        ),
        Command(
          name: 'progress',
          help: 'Progress bars',
          run: (_) => LoggingDemo.progress(),
        ),
      ],
    ),
    Command(
      name: 'ansi',
      help: 'Text styles, colours and terminal escapes',
      commands: [
        Command(
          name: 'styles',
          help: 'Bold, italic, underlines and more',
          run: (_) => AnsiDemo.styles(),
        ),
        Command(
          name: 'colours',
          aliases: ['colors'],
          help: '256 colours, true colour, the palette and blending',
          run: (_) => AnsiDemo.colours(),
        ),
        Command(
          name: 'escapes',
          help: 'Links, window title, taskbar, cursor moves and box characters',
          run: (_) => AnsiDemo.escapes(),
        ),
      ],
    ),
    Command(
      name: 'cmd',
      help: 'Files, paths, shell commands, processes and prompts',
      commands: [
        Command(
          name: 'draw',
          help: 'Boxes and tables',
          run: (_) => CmdDemo.draw(),
        ),
        Command(
          name: 'paths',
          help: 'Joining and splitting paths',
          run: (_) => CmdDemo.paths(),
        ),
        Command(
          name: 'files',
          help: 'File helpers, find and showTree',
          run: (_) => CmdDemo.files(),
        ),
        Command(
          name: 'system',
          help: 'Finding programs and checking for admin rights',
          run: (_) => CmdDemo.system(),
        ),
        Command(
          name: 'shell',
          help: 'Running shell commands and reading the results',
          run: (_) => CmdDemo.shell(),
        ),
        Command(
          name: 'folder',
          help: 'A cd that carries over to the next command',
          run: (_) => CmdDemo.terminalFolder(),
        ),
        Command(
          name: 'processes',
          help: 'Starting, reading and stopping programs',
          run: (_) => CmdDemo.processes(),
        ),
        Command(
          name: 'fetch',
          help: 'Download with a progress bar',
          run: (_) => CmdDemo.fetch(),
        ),
        Command(
          name: 'prompts',
          help: 'ask, confirm and the arrow-key menu',
          run: (_) => CmdDemo.prompts(),
        ),
        Command(
          name: 'interactive',
          help: 'A shell command that asks for your name',
          run: (_) => CmdDemo.interactiveCommand(),
        ),
        Command(
          name: 'open',
          help: 'Open dart.dev in your browser',
          run: (_) => CmdDemo.open(),
        ),
      ],
    ),
    Command(
      name: 'helpers',
      help: 'String, number, list and base helpers',
      commands: [
        Command(
          name: 'strings',
          help: 'Strings.* helpers, the String extension and graphemes',
          run: (_) => UtilsDemo.strings(),
        ),
        Command(
          name: 'numbers',
          help: 'num, int, double and list extensions',
          run: (_) => UtilsDemo.numbers(),
        ),
        Command(
          name: 'radix',
          help: 'Binary, hex, base 256 and Radix',
          run: (_) => UtilsDemo.radix(),
        ),
      ],
    ),
    Command(
      name: 'theme',
      help: 'Default and custom themes',
      run: (_) => CliDemo.theme(),
    ),
    Command(
      name: 'errors',
      help: 'What users see when they type something wrong',
      run: (_) => CliDemo.errors(cli),
    ),
    Command(
      name: 'greet',
      aliases: ['hi'],
      help: 'Flags, options and aliases: try "demo hi -N Ann -N Bo --shout"',
      flags: [
        const Flag(
          'shout',
          short: 's',
          help: 'Greet in capitals',
          negatable: true,
        ),
      ],
      options: [
        const Option(
          'name',
          short: 'N',
          help: 'Who to greet. Give it more than once for more people',
          valueName: 'who',
          multiple: true,
        ),
        const Option(
          'mood',
          short: 'M',
          help: 'How to greet',
          allowed: ['happy', 'calm', 'grumpy'],
          defaultValue: 'happy',
        ),
      ],
      run: (input) {
        final names = input.options('name');
        final who = input.wasGiven('name')
            ? Strings.conjuctionJoin(names, last: ' and ')
            : 'world';
        final word = switch (input.option('mood')) {
          'calm' => 'Hello',
          'grumpy' => 'Oh. Hi',
          _ => 'Hey there',
        };
        final greeting = '$word, $who!';
        pass(input.flag('shout') ? greeting.toUpperCase() : greeting);
        if (input.verbose) {
          debug('--verbose: names were $names');
          debug('--verbose: command path is ${input.commandPath}');
        }
      },
    ),
    Command(
      name: 'to',
      help: 'Show the saved path for a key',
      arguments: [
        const Argument('key', help: 'The saved key, like "home" or "temp"'),
        const Argument('sub', help: 'A folder inside it', required: false),
      ],
      run: (input) {
        final paths = {
          'home': CMD.fs.homeDirectory,
          'temp': Directory.systemTemp.path,
          'here': CMD.fs.pwd,
        };
        final key = input.argument('key');
        final path = paths[key];
        if (path == null) {
          fail('No path saved as "$key". Try ${paths.keys.join(', ')}.');

          return;
        }

        final sub = input.argument('sub');
        log(sub == null ? path : CMD.fs.join(path, sub));
      },
    ),
  ],
  run: (input) async {
    if (input.flag('all')) return _everything();

    final scene = input.option('scene');
    await _showcase(only: scene == null ? null : int.parse(scene));

    if (input.flag('hold')) await delay(5);
  },
);

Future<void> main(List<String> args) async {
  // ShellCommand uses PowerShell by default; most Macs and Linux boxes
  // don't have it.
  if (!Platform.isWindows) ShellCommand.defaultShell = TerminalShell.sh;

  await cli.start(args);
}

/// Runs every demo, the interactive ones last.
Future<void> _everything() async {
  await LoggingDemo.all();
  await AnsiDemo.all();
  await section('Theme', CliDemo.theme);
  await section('Errors', () => CliDemo.errors(cli));
  await CmdDemo.all();
  await UtilsDemo.all();
  await CmdDemo.interactive();
}

// ---------------------------------------------------------------------------
// The showcase: short, timed scenes recorded into the README GIFs by
// scripts/generate_gifs.ps1. Keep the order in step with the names there.
// ---------------------------------------------------------------------------

final List<(String, Future<void> Function())> _scenes = [
  ('Logging', _logging),
  ('Styling', _styling),
  ('Progress', _progress),
  ('Boxes and tables', _tables),
  ('Files', _files),
  ('Shell commands', _shell),
];

/// Plays every scene with an intro and outro, or just scene [only].
Future<void> _showcase({int? only}) async {
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

/// A short pause between lines, so the GIFs are easy to follow.
Future<void> _beat() => delay(0.25);

/// Clears the screen, prints the scene's title, then plays it.
Future<void> _scene(int number,
    String title,
    Future<void> Function() body,) async {
  final theme = AnsiTheme.current;
  _clear();
  AnsiTheme.say('');
  AnsiTheme.say(
    ' $number/${_scenes.length} '.dim + title.bold.foreground(theme.highlight),
  );
  AnsiTheme.say(' ${'─' * 40}'.dim.foreground(theme.border));
  AnsiTheme.say('');
  await delay(0.2);
  await body();
  await delay(1.6);
}

/// The title card.
Future<void> _intro() async {
  _clear();
  AnsiTheme.say('');
  AnsiTheme.say(
    CMD.draw.box(
      [
        'cmdline'.bold.foreground(AnsiPalette.sky),
        'Friendly command line tools in Dart'.dim,
      ].join('\n'),
    ),
  );
  await delay(1.5);
}

/// The closing card.
Future<void> _outro() async {
  _clear();
  AnsiTheme.say('');
  AnsiTheme.say(
    CMD.draw.box(
      [
        'dart pub add cmdline'.bold.foreground(AnsiPalette.mint),
        'Logging, prompts, styling, files and shell'.dim,
      ].join('\n'),
      title: 'Get started',
    ),
  );
  AnsiTheme.say('');
  await delay(2);
}

/// Scene 1: a spinner, then one line of each level.
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

/// Scene 2: text styles, the palette and a colour blend.
Future<void> _styling() async {
  AnsiTheme.say(
    [
      'bold'.bold,
      'dim'.dim,
      'italic'.italic,
      'underline'.underline,
      'curly'.curlyUnderline.underlineColour(AnsiPalette.rose),
      'strike'.strikethrough,
      'inverse'.inverse,
    ].join('  '),
  );
  await delay(0.5);
  AnsiTheme.say('');

  final palette = {
    'orchid': AnsiPalette.orchid,
    'mint': AnsiPalette.mint,
    'sky': AnsiPalette.sky,
    'lavender': AnsiPalette.lavender,
    'rose': AnsiPalette.rose,
    'peach': AnsiPalette.peach,
    'butter': AnsiPalette.butter,
    'aqua': AnsiPalette.aqua,
  };
  final names = palette.keys.toList();
  for (var row = 0; row < names.length; row += 4) {
    final cells = [
      for (final name in names.skip(row).take(4))
        '${'██'.foreground(palette[name]!)} ${name.padRight(9)}',
    ];
    AnsiTheme.say(cells.join(' '));
    await _beat();
  }
  AnsiTheme.say('');

  const width = 48;
  const chunk = 6;
  for (var start = 0; start < width; start += chunk) {
    for (var i = start; i < start + chunk; i++) {
      final amount = 1 - i / (width - 1);
      stdout.write(
        ' '.background(AnsiPalette.sky.opacity(amount, over: AnsiPalette.rose)),
      );
    }
    await delay(0.05);
  }
  stdout.writeln();
}

/// Scene 3: two progress bars that finish and one that fails.
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
    colour: AnsiPalette.sky,
  );
  await fill(download, 60, 1);
  download.done('Downloaded 12.4 MB');
  await _beat();

  final compile = ProgressBar(
    'Compiling  ',
    total: 40,
    colour: AnsiPalette.lavender,
  );
  await fill(compile, 40, 0.8);
  compile.done('Compiled 40 files');
  await _beat();

  final upload = ProgressBar(
    'Uploading  ',
    total: 50,
    colour: AnsiPalette.peach,
  );
  await fill(upload, 35, 0.7);
  await delay(0.3);
  upload.failed('Upload stopped at 70%');
}

/// Scene 4: a table with styled cells and a summary box.
Future<void> _tables() async {
  final ok = 'up to date'.foreground(AnsiPalette.mint);
  final old = 'update'.foreground(AnsiPalette.butter);
  AnsiTheme.say(
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
  AnsiTheme.say(
    CMD.draw.box(
      '${'2'.bold} packages can be updated.\n'
          'Run ${'dart pub upgrade'.foreground(AnsiPalette.sky)} to get them.',
      title: 'Summary',
    ),
  );
}

/// Scene 5: a small project shown as a tree, then searched.
Future<void> _files() async {
  final temp = tempFolder('cmdline_gif_');
  final app = CMD.fs.join(temp, 'my_app');
  try {
    writeFile(CMD.fs.join(app, 'pubspec.yaml'), 'name: my_app');
    writeFile(CMD.fs.join(app, 'README.md'), '# my_app');
    writeFile(CMD.fs.join(app, 'bin', 'my_app.dart'), 'void main() {}');
    writeFile(CMD.fs.joinAll([app, 'lib', 'src', 'app.dart']), '// app');
    writeFile(CMD.fs.join(app, 'test', 'app_test.dart'), '// tests');

    CMD.fs.showTree(app);
    await delay(0.6);
    AnsiTheme.say('');

    final found = await CMD.fs.find('*.dart', workingDirectory: app).toList();
    pass('Found ${found.length} Dart files');
    await _beat();
    for (final file in found) {
      AnsiTheme.say(
        '  ${AnsiTheme.current.pointer} ${CMD.fs.basename(file)}'.dim,
      );
      await _beat();
    }
  } finally {
    CMD.fs.deleteDir(temp);
  }
}

/// Scene 6: a command that works and one that fails.
Future<void> _shell() async {
  await ShellCommand.run('dart --version');
  await _beat();
  await ShellCommand.run('git rev-parse --verify no-such-branch');
}

/// Clears the screen and hides the cursor for the next scene.
void _clear() => stdout.write('$CLEAR_SCREEN$CURSOR_HOME$HIDE_CURSOR');
