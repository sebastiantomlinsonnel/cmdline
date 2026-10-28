import 'package:cmdline/cmdline.dart';

/// clear && dart run bin\bin.dart

void main(List<String> args) {
  CommandLineDemo.demo();
  CommandLineDemo.printMessages();

  Cli cli = Cli(
    name: 'run',
    version: '0.0.1',
    about: 'Make working in the terminal easier',
    flags: [const Flag('verbose', short: 'v')],
    commands: [
      Command(
        name: 'add',
        about: 'Add a task',
        options: [
          const Option('text', short: 't', required: true, help: 'What to do'),
          const Option('tag', multiple: true),
          const Option(
            'priority',
            allowed: ['low', 'high'],
            defaultValue: 'low',
          ),
        ],
        flags: [
          const Flag('urgent', short: 'u'),
          const Flag('color', negatable: true, defaultValue: true),
          const Flag('secret', hidden: true),
        ],
        run: (_) {},
      ),
      Command(
        name: 'list',
        aliases: ['ls'],
        flags: [const Flag('all', short: 'a')],
        run: (_) {},
      ),
    ],
  );
  cli.start(args);
}
