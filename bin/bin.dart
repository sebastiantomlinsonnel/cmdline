import 'package:cmdline/cmdline.dart';

List<String> _args = ['get', '-l'];
final CLI cli = CLI(
  [getCommands],
  flags: [const CLIFlag('verbose', 'Print more.', abbr: 'v')],
);

Future<void> main(List<String> args) async {
  _args = args;
  await cli.execute(_args);
}

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
