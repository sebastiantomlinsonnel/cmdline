import 'package:cmdline/cmdline.dart';

/// clear && dart run bin\bin.dart

void main(List<String> args) {
  // CommandLineDemo.demo();
  // CommandLineDemo.printMessages();

  Cli cli = Cli(
    name: 'run',
    version: '0.0.1',
    about: 'Make working in the terminal easier',
    flags: [Flag('verbose', short: 'v')],
    commands: [
      Command(
        name: 'add',
        about: 'Add a task',
        options: [
          Option('text', short: 't', required: true, help: 'What to do'),
          Option('tag', multiple: true),
          Option('priority', allowed: ['low', 'high'], defaultValue: 'low'),
        ],
        flags: [
          Flag('urgent', short: 'u'),
          Flag('color', negatable: true, defaultValue: true),
          Flag('secret', hidden: true),
        ],
        run: (_) {},
      ),
      Command(
        name: 'list',
        aliases: ['ls'],
        flags: [Flag('all', short: 'a')],
        run: (_) {},
      ),
    ],
  );
  cli.start(args);
}
