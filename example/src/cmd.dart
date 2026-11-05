import 'dart:io';

import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for the `CMD` helpers: drawing, files, paths, shell commands,
/// processes, downloads and prompts.
class CmdDemo {
  const CmdDemo._();

  /// Runs every demo that doesn't need you to type anything.
  static Future<void> all() async {
    await section('Boxes and tables', draw);
    await section('Paths', paths);
    await section('Files', files);
    await section('System', system);
    await section('Shell commands', shell);
    await section('Terminal folder', terminalFolder);
    await section('Processes', processes);
    await section('Download', fetch);
  }

  /// Runs every demo that asks you things or hands over the keyboard.
  ///
  /// Needs a real terminal for the arrow-key menu, hidden typing and the
  /// interactive command.
  static Future<void> interactive() async {
    await section('Prompts', prompts);
    await section('Interactive command', interactiveCommand);
    await section('Default app', open);
  }

  /// Shows a box and a table, with styled cells that still line up.
  static void draw() {
    final theme = CliTheme.current;
    CliTheme.say(
      CMD.draw.box('Boxes fit their text,\neven ${'styled'.bold.italic} text.'),
    );
    CliTheme.say(CMD.draw.box('With a title', title: 'Title'));
    CliTheme.say(
      CMD.draw.table(
        [
          ['fs.dart', 'Files and paths', 489],
          ['prompt.dart', 'Prompts', 230],
          ['net.dart', 'Downloads'.foreground(theme.highlight), 98],
        ],
        header: ['File', 'Area', 'Lines'],
        rightAligned: {2},
      ),
    );

    heading('padPlain pads by what you see, not by escape codes');
    for (final word in [
      'plain',
      'bold'.bold,
      'sky'.foreground(AnsiPalette.sky),
    ]) {
      CliTheme.say(
        '[${CMD.draw.padPlain(word, 8)}] [${CMD.draw.padPlain(word, 8, right: true)}]',
      );
    }
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
    showCalls([
      ['joinAll', file],
      ['join', CMD.fs.join('lib', 'src', 'app.dart')],
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
      ['homeDirectory', CMD.fs.homeDirectory],
      ['pwd', CMD.fs.pwd],
      ['globToRegExp', CMD.fs.globToRegExp('**/*.dart').pattern],
    ]);
  }

  /// Builds a small folder, shows it as a tree, searches it, then cleans up.
  static Future<void> files() async {
    final dir = tempFolder('cmdline_demo_');
    String at(String a, [String? b, String? c]) => CMD.fs.join(dir, a, b, c);
    try {
      writeFile(at('lib', 'main.dart'), 'void main() {}');
      writeFile(at('lib', 'src', 'helper.dart'), '// helper');
      writeFile(at('README.md'), '# Demo\nMore text\n');
      CMD.fs.touch(at('build', 'out.txt'));
      CMD.fs.createDir(at('empty'));
      CMD.fs.copy(at('README.md'), at('docs', 'README.md'));
      CMD.fs.copyTree(at('lib'), at('backup'));
      CMD.fs.moveTree(at('backup'), at('old'));
      CMD.fs.move(at('build', 'out.txt'), at('build', 'result.txt'));

      CMD.fs.showTree(dir);

      final found = await CMD.fs.find('*.dart', workingDirectory: dir).toList();
      log('find("*.dart") found ${found.length} files:');
      for (final file in found) {
        CliTheme.say(
          '  ${CliTheme.current.pointer} ${CMD.fs.basename(file)}'.dim,
        );
      }

      final changed = CMD.fs.replace(at('README.md'), 'Demo', 'Demo project');
      showCalls([
        ['replace("Demo", ...)', '$changed place(s) changed'],
        ['exists(README.md)', CMD.fs.exists(at('README.md'))],
        ['isFile(lib)', CMD.fs.isFile(at('lib'))],
        ['isDirectory(lib)', CMD.fs.isDirectory(at('lib'))],
        ['isLink(lib)', CMD.fs.isLink(at('lib'))],
        [
          'fileLength(README.md)',
          '${CMD.fs.fileLength(at('README.md'))} bytes',
        ],
        ['lastModified(README.md)', CMD.fs.lastModified(at('README.md'))],
      ]);

      heading('Mistakes give a FileError');
      try {
        CMD.fs.copy(at('README.md'), at('docs', 'README.md'));
      } on FileError catch (error) {
        CliTheme.say(error.styled);
      }
      CMD.fs.tryDeleteFile(at('not-there.txt'));
      log('tryDeleteFile and tryDeleteDir never throw');
    } finally {
      CMD.fs.deleteDir(dir);
    }
  }

  /// Finds programs on the PATH and checks for admin rights.
  static Future<void> system() async {
    showCalls([
      ['findProgram("dart")', await CMD.findProgram('dart') ?? 'not found'],
      ['findProgram("git")', await CMD.findProgram('git') ?? 'not found'],
      [
        'findProgram("no-such-tool")',
        await CMD.findProgram('no-such-tool') ?? 'not found',
      ],
      ['nextToScript("tool.exe")', CMD.nextToScript('tool.exe')],
      ['isPrivilegedUser()', await CMD.isPrivilegedUser()],
      ['quoteWrap("it\'s")', CMD.quoteWrap("it's")],
    ]);
  }

  /// Runs shell commands, reads their results, and handles a failure.
  static Future<void> shell() async {
    await ShellCommand.run('dart --version');

    final branch = await ShellCommand.run(
      'git branch --show-current',
      show: false,
    );
    log('Git branch: ${branch.ok ? branch.output.trim() : '(not a repo)'}');

    final listing = await ShellCommand.run(
      Platform.isWindows ? 'Get-ChildItem -Name' : 'ls',
      show: false,
    );
    log('This folder has ${listing.lines.length} entries');

    final failing = await ShellCommand.run('exit 3', show: false);
    log(
      'The failing command gave exit code ${failing.exitCode} '
      '(ok: ${failing.ok}, failed: ${failing.failed})',
    );

    try {
      failing.throwIfFailed();
    } on ProcessFailed catch (error) {
      warn('Caught ProcessFailed: $error');
    }
  }

  /// Shows that a `cd` carries over to the next command.
  static Future<void> terminalFolder() async {
    final start = ShellCommand.directory;
    try {
      await ShellCommand.run('cd ${_quoted(Directory.systemTemp.path)}');
      log('After cd, commands run in: ${ShellCommand.directory}');

      if (Platform.isWindows) {
        final viaCmd = await ShellCommand.run(
          'cd',
          shell: TerminalShell.cmd,
          show: false,
        );
        log('cmd agrees: ${viaCmd.output.trim()}');
      }
    } finally {
      ShellCommand.directory = start;
    }
  }

  /// Starts a program, reads its output, and stops one that runs too long.
  static Future<void> processes() async {
    final dart = await Process.start('dart', ['--version'], runInShell: true);
    await dart.closeInput();
    final (lines, errors) = await (
      dart.stdout.lines.toList(),
      dart.stderr.text,
    ).wait;
    final said = [...lines, errors.trim()].where((line) => line.isNotEmpty);
    log('dart said: ${said.join(' ')}');
    log('It finished ok: ${await dart.ok}');

    final slow = Platform.isWindows
        ? await Process.start('ping', ['-n', '30', '127.0.0.1'])
        : await Process.start('sleep', ['30']);
    final code = await slow.waitFor(const Duration(seconds: 1));
    log(
      code == null
          ? 'waitFor: the slow program was stopped after 1 second'
          : 'waitFor: the slow program finished with $code',
    );
  }

  /// Downloads a small file with a progress bar, then shows it.
  static Future<void> fetch() async {
    final dir = tempFolder('cmdline_fetch_');
    try {
      final saveTo = CMD.fs.join(dir, 'VERSION.json');
      await CMD.net.fetch(
        'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
        saveTo,
      );
      CliTheme.say(
        CMD.draw.box(
          File(saveTo).readAsStringSync().trim(),
          title: 'Latest Dart',
        ),
      );
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
    await ShellCommand.run(command, interactive: true);
  }

  /// Opens a web page in the browser, if you say yes.
  static Future<void> open() async {
    if (CMD.prompt.confirm(
      'Open dart.dev in your browser?',
      defaultValue: false,
    )) {
      await CMD.openWithDefaultApp('https://dart.dev');
      pass('Opened dart.dev');
    } else {
      log('Skipped opening the browser');
    }
  }

  /// Quotes [path] for the default shell.
  static String _quoted(String path) => Platform.isWindows
      ? CMD.quoteWrap(path)
      : "'${path.replaceAll("'", r"'\''")}'";
}
