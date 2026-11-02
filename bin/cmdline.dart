import 'package:cmdline/cmdline.dart';

final cli = CLI(
  name: 'example',
  about: 'A basic todo example app',
  commands: [
    Command(
      name: 'profile',
      run: (input) async {
        await TerminalCommand.run(
          r'(Get-Content $PROFILE).contains("# RUN.EXE")',
        );
      },
    ),
    Command(
      name: 'demo',
      about: 'Everything that needs no typing',
      run: (input) => CommandLineDemo.demo(),
    ),
    Command(
      name: 'demo-all',
      about: 'Prompts, menus and other things that need typing',
      run: (input) => CommandLineDemo.demoAll(),
    ),
    Command(
      name: 'cli',
      about: 'Try the cli helpers',
      commands: [
        Command(
          name: 'theme',
          about: 'Default and custom themes',
          run: (input) => CommandLineDemo.theme(),
        ),
        Command(
          name: 'files',
          about: 'File helpers, find and showTree',
          run: (input) => CommandLineDemo.files(),
        ),
        Command(
          name: 'prompts',
          about: 'ask, confirm and the arrow-key menu',
          run: (input) => CommandLineDemo.prompts(),
        ),
        Command(
          name: 'format',
          about: 'Boxes and tables',
          run: (input) => CommandLineDemo.format(),
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
          name: 'paths',
          about: 'Joining and splitting paths',
          run: (input) => CommandLineDemo.paths(),
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
      ],
    ),
    Command(
      name: 'add',
      about: 'Add a task',
      options: [
        const Option('text', short: 'T', help: 'What to do', required: true),
        const Option('tag', help: 'Label the task', multiple: true),
        const Option('priority', allowed: ['low', 'high'], defaultValue: 'low'),
      ],
      flags: [const Flag('urgent', short: 'u', help: 'Mark as urgent')],
      run: (input) {
        final urgent = input.flag('urgent') ? ' (urgent!)' : '';
        pass('Added "${input.option('text')}"$urgent');
        log('Priority: ${input.option('priority')}');
        log('Tags: ${input.options('tag')}');

        if (input.flag('verbose')) {
          trace('Commands: ${input.commandPath}');
        }
      },
    ),
    Command(
      name: 'list',
      about: 'Show your tasks',
      aliases: ['ls'],
      flags: [const Flag('all', short: 'a', help: 'Include finished tasks')],
      run: (input) {
        fail(input.flag('all') ? 'All tasks: none yet' : 'Tasks: none yet');
      },
    ),
  ],
  run: (input) {
    input.help();
  },
);

Future<void> main(List<String> args) async {
  // Logger.instance.startSpinner('Spinner...', level: Level.trace);
  // await delay(10);
  cli.start(args);
}
