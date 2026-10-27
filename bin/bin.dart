import 'package:cmdline/cli.dart';
import 'package:cmdline/msend.dart';

List<String> _args = ['get', '-l'];
final CLI cli = CLI(
  [getCommands],
  flags: [const CliFlag('verbose', 'Print more.', abbr: 'v')],
);

Future<void> main(List<String> args) async {
  _args = args;
  await cli.execute(_args);
}

CliCommand getCommands = CliCommand(
  name: 'get',
  description: 'Commands for getting values',
  subCommands: [
    CliCommand(
      name: 'ip',
      description: 'Gets your IP address',
      flags: [const CliFlag('local', 'Gets only the local IP')],
      run: (result) {
        String a = result.flag('local') ? 'only local IP' : 'both IPs';
        debug('Getting $a');
      },
    ),
  ],
);
