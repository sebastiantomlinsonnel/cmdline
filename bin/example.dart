import 'package:cmdline/cmdline.dart';

final cli = CLI(
  name: 'example',
  about: 'A basic todo example app',
  commands: [
    /// ADD
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

    /// LIST
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
