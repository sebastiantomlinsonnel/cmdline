import 'dart:io';

import 'package:cmdline/cmdline.dart';

CLICommand getCommands = CLICommand(
  name: 'get',
  description: 'Commands for getting values',
  subCommands: [
    CLICommand(
      name: 'ip',
      description: 'Gets your IP address',
      flags: [const CLIFlag('local', 'Gets only the local IP')],
      run: (flags, options) {
        String a = flags['local']! ? 'only local IP' : 'both IPs';
        debug('Getting $a');
      },
    ),
  ],
);

final CLI cli = CLI(
  'bin',
  description: 'Runners',
  subCommands: [getCommands],
  flags: [const CLIFlag('verbose', 'Print more.', abbr: 'v')],
);

Future<void> main(List<String> args) async {
  final runner = cli.build();
  try {
    final command = runner.parse(args);
    await command.run(runner.flags, runner.options);
  } on CLIException catch (e) {
    stderr.writeln('Error: ${e.message}');
  }
}
