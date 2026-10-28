import 'package:cmdline/cmdline.dart';

/// clear && dart run bin\example.dart

void main(List<String> args) {
  // CommandLineDemo.demo();

  final cli = Cli(
    name: 'todo',
    about: 'A demo todo app',
    version: '0.0.1',
    flags: [const Flag('verbose', short: 'v', help: 'Print extra detail')],
    commands: [
      Command(name: 'demo', run: (input) => CommandLineDemo.printMessages()),
      Command(
        name: 'add',
        about: 'Add a task',
        options: [
          const Option('text', short: 't', help: 'What to do', required: true),
          const Option('tag', help: 'Label the task', multiple: true),
          const Option(
            'priority',
            allowed: ['low', 'high'],
            defaultValue: 'low',
          ),
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
  );

  cli.start(args);
}
