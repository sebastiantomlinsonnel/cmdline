import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Small runnable tours of what the package can do.
///
/// [demo] runs everything that needs no typing, so it works anywhere, even
/// with output piped to a file. [demoAll] runs the parts that ask you
/// things or hand over the keyboard, so it needs a real terminal.
class CommandLineDemo {
  const CommandLineDemo._();

  /// Runs every demo that doesn't need you to type anything.
  static Future<void> demo() async {
    await _section('Logger', () async {
      await spinnerDemo();
      printMessages();
      await logFile();
    });
    await _section('Progress bar', () => progressBar());
    await _section('Theme', () => theme());
    await _section('Boxes and tables', () => format());
    await _section('Paths', () => paths());
    await _section('Files', () => files());
    await _section('Shell commands', () => shell());
    await _section('Terminal folder', () => terminalFolder());
    await _section('Processes', () => processes());
    await _section('Download', () => download());
  }

  /// Runs every demo that asks you things or hands over the keyboard.
  ///
  /// Needs a real terminal for the arrow-key menu, hidden typing and the
  /// interactive command.
  static Future<void> demoAll() async {
    await _section('Prompts', () => prompts());
    await _section('Interactive command', () => interactiveCommand());
    await _section('Default app', () => openApp());
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

    return Logger.instance.getString('Built, not logged', Level.debug);
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
      await Logger.open(path, append: false);
      log('This line goes to the screen and to demo.log');
      warn('So does this warning');
      await Logger.close();

      CliTheme.say(CMD.draw.box(path.readText.trim(), title: 'demo.log'));
    } finally {
      await Logger.close();
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
      colour: AsciiPalette.peach,
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
      question: AsciiColour(13),
      border: AsciiColour(13),
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
