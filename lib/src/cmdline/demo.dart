import 'dart:io';

import 'package:cmdline/cmdline.dart';

class CommandLineDemo {
  const CommandLineDemo._();

  static Future<String> demo() async {
    Logger.instance.startSpinner('Starting logger');
    await delay(3);
    Logger.instance.stopSpinner('Loading Complete!', Level.pass);

    return Logger.instance.getString('Built, not logged', Level.debug);
  }

  static void printMessages() {
    trace('This is a trace message');
    debug('This is a $BOLD debug message');
    fail('This type shows that something has FAILED');
    Logger.instance.showTimestampInOutput = true;
    pass('This type shows that something has NOT failed');
    warn('This will show when you want to warn');
    dev('Dev messages only show in debug mode and aren\'t logged');
  }

  /// Shows the default theme, then the same box with a custom theme.
  static void theme() {
    final theme = CliTheme.current;
    CliTheme.say(theme.successLine('A success line'));
    CliTheme.say(theme.errorLine('An error line'));
    CliTheme.say(box('The default theme', title: 'Theme'));

    CliTheme.current = const CliTheme(
      question: AsciiColour(13),
      border: AsciiColour(13),
      box: BoxChars.doubleLine,
      tick: '+',
    );
    CliTheme.say(CliTheme.current.successLine('A custom theme'));
    CliTheme.say(box('Double lines in pink', title: 'Custom'));
    CliTheme.current = const CliTheme();
  }

  /// Builds a small folder, shows it as a tree, searches it, then cleans up.
  static Future<void> files() async {
    final dir = Directory.systemTemp.createTempSync('cmdline_demo_').path;
    try {
      join(dir, 'lib', 'main.dart').write('void main() {}');
      join(dir, 'lib', 'src', 'helper.dart').write('// helper');
      join(dir, 'README.md').write('# Demo');
      touch(join(dir, 'build', 'out.txt'));
      copy(join(dir, 'README.md'), join(dir, 'docs', 'README.md'));

      showTree(dir);

      final found = await find('*.dart', workingDirectory: dir).toList();
      log('Found ${found.length} Dart files:');
      found.map((file) => '  ${basename(file)}'.bold).forEach(CliTheme.say);

      final changed = replace(join(dir, 'README.md'), 'Demo', 'Demo project');
      log('Changed $changed place(s) in README.md');

      try {
        copy(join(dir, 'README.md'), join(dir, 'docs', 'README.md'));
      } on FileError catch (error) {
        CliTheme.say(error.styled);
      }
    } finally {
      deleteDir(dir);
    }
  }

  /// Asks a few questions and shows the answers in a box.
  ///
  /// Needs a real terminal for the arrow-key menu and hidden typing.
  static void prompts() {
    final name = ask('Project name', defaultValue: 'my_app');
    final port = ask(
      'Port',
      defaultValue: '8080',
      validator: (answer) =>
          int.tryParse(answer) == null ? 'Type a number' : null,
    );
    final secret = ask('Password', hidden: true, required: false);
    final colour = menu('Favourite colour', [
      'Red',
      'Green',
      'Blue',
      'Purple',
    ], defaultOption: 'Green');
    final save = confirm('Save these settings?', defaultValue: true);

    CliTheme.say(
      box(
        [
          'Name:     ${name.bold}',
          'Port:     $port',
          'Password: ${'*' * secret.length}',
          'Colour:   $colour',
          'Saved:    ${save ? 'yes' : 'no'}',
        ].join('\n'),
        title: 'Answers',
      ),
    );
  }

  /// Shows a box and a table, with styled cells that still line up.
  static void format() {
    final theme = CliTheme.current;
    CliTheme.say(
      box('Boxes fit their text,\neven ${'styled'.bold.italic} text.'),
    );
    CliTheme.say(
      table(
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

  /// Looks up programs, changes a variable and shows PATH.
  static Future<void> environment() async {
    for (final program in ['dart', 'git', 'cmdline_missing_tool']) {
      final found = which(program);
      CliTheme.say(
        found == null
            ? CliTheme.current.errorLine('$program not found')
            : CliTheme.current.successLine('$program: $found'),
      );
    }

    env['CMDLINE_DEMO'] = 'set from Dart';
    final command = Platform.isWindows
        ? r'$env:CMDLINE_DEMO'
        : r'echo "$CMDLINE_DEMO"';
    log('A command sees: ${await command.firstLine}');
    env['CMDLINE_DEMO'] = null;

    env.printAll(only: '*PATH*');
  }

  /// Runs commands from strings, including one that fails.
  static Future<void> shell() async {
    await 'dart --version'.run;
    final branch = await 'git branch --show-current'.start(
      show: false,
      nothrow: true,
    );
    log('Git branch: ${branch.ok ? branch.output.trim() : '(not a repo)'}');

    final failing = Platform.isWindows ? 'cmd /c exit 3' : 'exit 3';
    final result = await failing.start(nothrow: true);
    log('The failing command gave exit code ${result.exitCode}');

    log('Running as admin/root: ${await isPrivilegedUser}');
  }

  /// Downloads a small file with a progress bar, then shows it.
  static Future<void> download() async {
    final dir = Directory.systemTemp.createTempSync('cmdline_fetch_').path;
    try {
      final saveTo = join(dir, 'VERSION.json');
      await fetch(
        'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
        saveTo,
      );
      CliTheme.say(box(saveTo.readText.trim(), title: 'Latest Dart'));
    } finally {
      deleteDir(dir);
    }
  }
}
