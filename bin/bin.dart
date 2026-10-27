import 'dart:io';

import 'package:cmdline/cmdline.dart';

final CLI cli = CLI(
  'bin',
  description: 'Runners',
  subCommands: [
    CLICommand(
      name: 'get',
      description: 'Commands for getting values',
      run: (flags, options) {
        trace('Get it right');
      },
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
      flags: [const CLIFlag('verbose', 'Print more.', abbr: 'v')],
    ),
  ],
);

Future<void> main(List<String> args) async {
  stdout.write('\n');
  log('Started running with args $args');
  CLIRunner runner = cli.build();
  CLICommand command = runner.parse(args);
  await command.run(runner.flags, runner.options);
}
