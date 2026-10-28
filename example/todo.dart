import 'package:cmdline/cmdline.dart';

/// A tiny todo app that shows every part of the CLI classes.
///
/// Try:
/// * `dart run example/todo.dart --help`
/// * `dart run example/todo.dart add -t "Buy milk" -u --tag home --tag shop`
/// * `dart run example/todo.dart ls --all`
final cli = Cli(
  name: 'todo',
  about: 'A tiny todo app',
  version: '1.0.0',
  flags: [Flag('verbose', short: 'v', help: 'Print extra detail')],
  commands: [
    Command(
      name: 'add',
      about: 'Add a task',
      options: [
        Option('text', short: 't', help: 'What to do', required: true),
        Option('tag', help: 'Label the task', multiple: true),
        Option('priority', allowed: ['low', 'high'], defaultValue: 'low'),
      ],
      flags: [Flag('urgent', short: 'u', help: 'Mark as urgent')],
      run: (input) {
        final urgent = input.flag('urgent') ? ' (urgent!)' : '';
        print('Added "${input.option('text')}"$urgent');
        print('Priority: ${input.option('priority')}');
        print('Tags: ${input.options('tag')}');

        if (input.flag('verbose')) {
          print('Commands: ${input.commandPath}');
        }
      },
    ),
    Command(
      name: 'list',
      about: 'Show your tasks',
      aliases: ['ls'],
      flags: [Flag('all', short: 'a', help: 'Include finished tasks')],
      run: (input) {
        print(input.flag('all') ? 'All tasks: none yet' : 'Tasks: none yet');
      },
    ),
  ],
);

void main(List<String> arguments) => cli.start(arguments);
