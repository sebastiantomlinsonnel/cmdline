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
      CommandLineDemo.demoAll();
    } else {
      return CommandLineDemo.demo();
    }
  },
);

Future<void> main(List<String> args) async => await cli.start(args);
