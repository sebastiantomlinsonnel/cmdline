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
      run: (result) {
        String a = result.flag('local') ? 'only local IP' : 'both IPs';
        debug('Getting $a');
      },
    ),
  ],
);

final CLI cli = CLI(
  [getCommands],
  flags: [const CLIFlag('verbose', 'Print more.', abbr: 'v')],
);

Future<void> main(List<String> args) async {
  final runner = cli.build();
  try {
    final result = runner.parse(args);
    if (result == null) {
      stdout.writeln(runner.usage());
      return;
    }
    await result.run();
  } on CLIException catch (e) {
    stderr.writeln('Error: ${e.message}\n\n${runner.usage()}');
  }
}
