import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

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
        if (path == null) {
          return fail('No path saved as "${input.argument('key')}".');
        }

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

class CommandLineDemo {
  const CommandLineDemo._();

  /// Runs every demo that doesn't need you to type anything.
  static Future<void> demo() async {
    await _section('Logger', () async {
      await spinnerDemo();
      printMessages();
      await logFile();
    });
    await _section('Progress bar', progressBar);
    await _section('Theme', theme);
    await _section('Boxes and tables', format);
    await _section('Paths', paths);
    await _section('Files', files);
    await _section('Shell commands', shell);
    await _section('Terminal folder', terminalFolder);
    await _section('Processes', processes);
    await _section('Download', download);
  }

  /// Runs every demo that asks you things or hands over the keyboard.
  ///
  /// Needs a real terminal for the arrow-key menu, hidden typing and the
  /// interactive command.
  static Future<void> demoAll() async {
    await _section('Prompts', prompts);
    await _section('Interactive command', interactiveCommand);
    await _section('Default app', openApp);
  }

  /// Prints a heading for one part of the demo, then runs it.
  ///
  /// If the part throws, the error is shown and the demo moves on.
  static Future<void> _section(
    String title,
    FutureOr<void> Function() part,
  ) async {
    CliTheme.say('');
    CliTheme.say(
      ' $title '.bold.inverse.foreground(CliTheme.current.highlight),
    );
    try {
      await part();
    } catch (error) {
      fail('$title failed: $error');
    }
  }

  /// Shows a spinner, then turns it into a PASS line.
  static Future<String> spinnerDemo() async {
    Logger.instance.startSpinner('Starting logger');
    await delay(1.5);
    Logger.instance.stopSpinner('Loading Complete!', Level.pass);

    final result = await spinWhile(
      'Asking dart for its version',
      Process.run('dart', ['--version']),
    );
    log('dart --version gave exit code ${result.exitCode}');

    return Logger.getString('Built, not logged', Level.debug);
  }

  /// Prints one message of each log level.
  static void printMessages() {
    trace('This is a trace message');
    debug('This is a $BOLD debug message');
    fail('This type shows that something has FAILED');
    Logger.instance.showTimestampInOutput = true;
    pass('This type shows that something has NOT failed');
    warn('This will show when you want to warn');
    Logger.instance.showTimestampInOutput = false;
    dev('Dev messages only show in debug mode and aren\'t logged');
    log('Plain log messages look like this');
  }

  /// Saves log messages to a file, then shows what the file holds.
  static Future<void> logFile() async {
    final dir = Directory.systemTemp.createTempSync('cmdline_log_').path;
    final path = CMD.fs.join(dir, 'demo.log');
    try {
      await Logger.instance.open(path, append: false);
      log('This line goes to the screen and to demo.log');
      warn('So does this warning');
      Logger.instance.close();

      CliTheme.say(CMD.draw.box(path.readText.trim(), title: 'demo.log'));
    } finally {
      Logger.instance.close();
      CMD.fs.deleteDir(dir);
    }
  }

  /// Fills a progress bar, then one that fails.
  static Future<void> progressBar() async {
    final bar = ProgressBar('Copying files', total: 40);
    for (var i = 0; i < 40; i++) {
      await delay(0.03);
      bar.add();
    }
    bar.done('Copied 40 files');

    final broken = ProgressBar(
      'Uploading',
      total: 10,
      colour: AnsiPalette.peach,
    );
    for (var i = 0; i < 6; i++) {
      await delay(0.05);
      broken.add();
    }
    broken.failed('Upload stopped at 60%');
  }

  /// Shows the default theme, then the same box with a custom theme.
  static void theme() {
    final theme = CliTheme.current;
    CliTheme.say(theme.successLine('A success line'));
    CliTheme.say(theme.errorLine('An error line'));
    CliTheme.say(CMD.draw.box('The default theme', title: 'Theme'));

    CliTheme.current = const CliTheme(
      question: AnsiColour(13),
      border: AnsiColour(13),
      box: BoxChars.doubleLine,
      tick: '+',
    );
    CliTheme.say(CliTheme.current.successLine('A custom theme'));
    CliTheme.say(CMD.draw.box('Double lines in pink', title: 'Custom'));
    CliTheme.current = const CliTheme();
  }

  /// Shows a box and a table, with styled cells that still line up.
  static void format() {
    final theme = CliTheme.current;
    CliTheme.say(
      CMD.draw.box('Boxes fit their text,\neven ${'styled'.bold.italic} text.'),
    );
    CliTheme.say(
      CMD.draw.table(
        [
          ['paths.dart', 'Paths', 212],
          ['menu.dart', 'Prompts', 230],
          ['fetch.dart', 'Downloads'.foreground(theme.highlight), 98],
        ],
        header: ['File', 'Area', 'Lines'],
        rightAligned: {2},
      ),
    );
  }

  /// Builds and takes apart a few paths.
  static void paths() {
    final file = CMD.fs.joinAll([
      CMD.fs.homeDirectory,
      'projects',
      'app',
      'lib',
      'main.dart',
    ]);
    CliTheme.say(
      CMD.draw.table(
        [
          ['join', file],
          ['basename', CMD.fs.basename(file)],
          ['basenameWithoutExtension', CMD.fs.basenameWithoutExtension(file)],
          ['fileExtension', CMD.fs.fileExtension(file)],
          ['dirname', CMD.fs.dirname(file)],
          [
            'normalize',
            CMD.fs.normalize(CMD.fs.joinAll(['a', '..', 'b', '.', 'c'])),
          ],
          ['isAbsolute', CMD.fs.isAbsolute(file)],
          ['absolute', CMD.fs.absolute('lib')],
          ['pwd', CMD.fs.pwd],
        ],
        header: ['Function', 'Result'],
      ),
    );
  }

  /// Builds a small folder, shows it as a tree, searches it, then cleans up.
  static Future<void> files() async {
    final dir = Directory.systemTemp.createTempSync('cmdline_demo_').path;
    try {
      CMD.fs.join(dir, 'lib', 'main.dart').write('void main() {}');
      CMD.fs.join(dir, 'lib', 'src', 'helper.dart').write('// helper');
      CMD.fs.join(dir, 'README.md').write('# Demo');
      CMD.fs.join(dir, 'README.md').append('More text');
      CMD.fs.touch(CMD.fs.join(dir, 'build', 'out.txt'));
      CMD.fs.copy(
        CMD.fs.join(dir, 'README.md'),
        CMD.fs.join(dir, 'docs', 'README.md'),
      );
      CMD.fs.copyTree(CMD.fs.join(dir, 'lib'), CMD.fs.join(dir, 'backup'));

      CMD.fs.showTree(dir);

      final found = await CMD.fs.find('*.dart', workingDirectory: dir).toList();
      log('Found ${found.length} Dart files:');
      found
          .map((file) => '  ${CMD.fs.basename(file)}'.bold)
          .forEach(CliTheme.say);

      final changed = CMD.fs.replace(
        CMD.fs.join(dir, 'README.md'),
        'Demo',
        'Demo project',
      );
      log('Changed $changed place(s) in README.md');
      log('README.md lines: ${CMD.fs.join(dir, 'README.md').readLines}');
      log(
        'README.md is ${CMD.fs.fileLength(CMD.fs.join(dir, 'README.md'))} bytes',
      );

      try {
        CMD.fs.copy(
          CMD.fs.join(dir, 'README.md'),
          CMD.fs.join(dir, 'docs', 'README.md'),
        );
      } on FileError catch (error) {
        CliTheme.say(error.styled);
      }
    } finally {
      CMD.fs.deleteDir(dir);
    }
  }

  /// Runs commands from strings, including one that fails.
  static Future<void> shell() async {
    await 'dart --version'.run;
    final branch = await 'git branch --show-current'.start(
      show: false,
      nothrow: true,
    );
    log('Git branch: ${branch.ok ? branch.output.trim() : '(not a repo)'}');

    final listing = Platform.isWindows ? 'Get-ChildItem -Name' : 'ls';
    final names = await listing.toList(nothrow: true);
    log('This folder has ${names.length} entries');

    final failing = Platform.isWindows ? 'cmd /c exit 3' : 'exit 3';
    final result = await failing.start(nothrow: true);
    log('The failing command gave exit code ${result.exitCode}');

    try {
      await failing.start(show: false);
    } on ProcessFailed catch (error) {
      warn('Caught ProcessFailed: $error');
    }

    log('Running as admin/root: ${await CMD.shell.isPrivilegedUser}');
  }

  /// Shows that a `cd` carries over to the next command.
  static Future<void> terminalFolder() async {
    final start = TerminalCommand.directory;
    try {
      await TerminalCommand.run('cd ${_quoted(Directory.systemTemp.path)}');
      log('After cd, commands run in: ${TerminalCommand.directory}');

      if (Platform.isWindows) {
        final viaCmd = await TerminalCommand.run(
          'cd',
          shell: TerminalShell.cmd,
          show: false,
        );
        log('cmd agrees: ${viaCmd.output.trim()}');
      }
    } finally {
      TerminalCommand.directory = start;
    }
  }

  /// Starts a program, reads its lines, and stops one that runs too long.
  static Future<void> processes() async {
    final echo = await Process.start('dart', ['--version']);
    await echo.closeInput();
    final lines = await echo.stdout.lines.toList();
    final errors = await echo.stderr.text;
    log(
      'dart printed ${lines.length} line(s): ${[...lines, errors.trim()].where((line) => line.isNotEmpty).join(' ')}',
    );

    final slow = Platform.isWindows
        ? await Process.start('ping', ['-n', '30', '127.0.0.1'])
        : await Process.start('sleep', ['30']);
    final code = await slow.waitFor(const Duration(seconds: 1));
    log(
      code == null
          ? 'The slow program was stopped after 1 second'
          : 'The slow program finished with $code',
    );
  }

  /// Downloads a small file with a progress bar, then shows it.
  static Future<void> download() async {
    final dir = Directory.systemTemp.createTempSync('cmdline_fetch_').path;
    try {
      final saveTo = CMD.fs.join(dir, 'VERSION.json');
      await CMD.net.fetch(
        'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
        saveTo,
      );
      CliTheme.say(CMD.draw.box(saveTo.readText.trim(), title: 'Latest Dart'));
    } finally {
      CMD.fs.deleteDir(dir);
    }
  }

  /// Asks a few questions and shows the answers in a box.
  ///
  /// Needs a real terminal for the arrow-key menu and hidden typing.
  static void prompts() {
    final name = CMD.prompt.ask('Project name', defaultValue: 'my_app');
    final port = CMD.prompt.ask(
      'Port',
      defaultValue: '8080',
      validator: (answer) =>
          int.tryParse(answer) == null ? 'Type a number' : null,
    );
    final secret = CMD.prompt.ask('Password', hidden: true, required: false);
    final colour = CMD.prompt.menu('Favourite colour', [
      'Red',
      'Green',
      'Blue',
      'Purple',
    ], defaultOption: 'Green');
    final file = CMD.prompt.menu('Pick a file', [
      'lib/main.dart',
      'lib/src/app.dart',
      'test/app_test.dart',
    ], format: CMD.fs.basename);
    final save = CMD.prompt.confirm('Save these settings?', defaultValue: true);

    CliTheme.say(
      CMD.draw.box(
        [
          'Name:     ${name.bold}',
          'Port:     $port',
          'Password: ${'*' * secret.length}',
          'Colour:   $colour',
          'File:     $file',
          'Saved:    ${save ? 'yes' : 'no'}',
        ].join('\n'),
        title: 'Answers',
      ),
    );
  }

  /// Hands the keyboard to a shell command that asks a question.
  static Future<void> interactiveCommand() async {
    final command = Platform.isWindows
        ? r'$name = Read-Host "Type your name"; Write-Host "Hello, $name"'
        : r'printf "Type your name: "; read name; echo "Hello, $name"';
    await command.start(interactive: true);
  }

  /// Opens a web page in the browser, if you say yes.
  static Future<void> openApp() async {
    if (CMD.prompt.confirm(
      'Open dart.dev in your browser?',
      defaultValue: false,
    )) {
      await openWithDefaultApp('https://dart.dev');
      pass('Opened dart.dev');
    } else {
      log('Skipped opening the browser');
    }
  }

  /// Quotes [path] for the default shell.
  static String _quoted(String path) => Platform.isWindows
      ? "'${path.replaceAll("'", "''")}'"
      : "'${path.replaceAll("'", r"'\''")}'";
}

final List<(String, Future<void> Function())> _scenes = [
  ('Logging', _logging),
  ('Styling', _styling),
  ('Progress', _progress),
  ('Boxes and tables', _tables),
  ('Files', _files),
  ('Shell commands', _shell),
];

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
        'cmdline'.bold.foreground(AnsiPalette.sky),
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
        'dart pub add cmdline'.bold.foreground(AnsiPalette.mint),
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
      'curly'.curlyUnderline.underlineColour(AnsiPalette.rose),
      'strike'.strikethrough,
      'inverse'.inverse,
    ].join('  '),
  );
  await delay(0.5);
  CliTheme.say('');

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
        ' '.background(AnsiPalette.sky.opacity(amount, over: AnsiPalette.rose)),
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

Future<void> _tables() async {
  final ok = 'up to date'.foreground(AnsiPalette.mint);
  final old = 'update'.foreground(AnsiPalette.butter);
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
      'Run ${'dart pub upgrade'.foreground(AnsiPalette.sky)} to get them.',
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
