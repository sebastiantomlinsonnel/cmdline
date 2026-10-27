import 'package:cmdline/cmdline.dart';

class CLICommand {
  final String name;
  final String description;
  final List<String> aliases;
  final bool hidden;
  final List<CLICommand> subCommands;
  final List<CLIFlag> flags;
  final List<CLIOption> options;
  final List<CLIArgument> arguments;

  /// Leave as [doNothing] for a pure group command: running it shows help.
  final CliRun run;

  const CLICommand({
    required this.name,
    required this.description,
    this.run = doNothing,
    this.aliases = const [],
    this.hidden = false,
    this.subCommands = const [],
    this.flags = const [],
    this.options = const [],
    this.arguments = const [],
  });

  CLICommand? findSubCommand(String token) {
    for (final c in subCommands) {
      if (c.name == token || c.aliases.contains(token)) return c;
    }
    return null;
  }
}
