import 'dart:io';

import 'package:cmdline/cli.dart';

Future<void> main(List<String> args) async {
  final cli = CLI(
    name: 'mytool',
    description: 'My tool.',
    flags: [CliFlag('verbose', 'Print more.', abbr: 'v')],
    [
      CliCommand(
        name: 'db',
        description: 'Database commands.',
        options: [CliOption('url', 'Database URL.')],
        subCommands: [
          CliCommand(
            name: 'migrate',
            description: 'Run migrations.',
            aliases: ['m'],
            flags: [CliFlag('dry-run', 'Show what would run.')],
            arguments: [
              CliArgument(
                'files',
                'Migration files.',
                variadic: true,
                required: false,
              ),
            ],
            run: (r) => print(
              'migrate dry=${r.flag('dry-run')} '
              'url=${r.option('url')} verbose=${r.flag('verbose')} files=${r.arguments('files')}',
            ),
          ),
        ],
      ),
    ],
  );

  exitCode = await cli.execute(args);
  // mytool -v db --url=x m --dry-run a.sql b.sql
}
