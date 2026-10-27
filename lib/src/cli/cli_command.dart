import 'package:cmdline/cmdline.dart';

class CliCommand {
  final String name;
  final String description;
  final List<String> aliases;
  final bool hidden;
  final List<CliCommand> subCommands;
  final List<CliFlag> flags;
  final List<CliOption> options;
  final List<CliArgument> arguments;

  /// Leave as [doNothing] for a pure group command: running it shows help.
  final CliRun run;

  const CliCommand({
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

  CliCommand? findSubCommand(String token) {
    for (final c in subCommands) {
      if (c.name == token || c.aliases.contains(token)) return c;
    }
    return null;
  }
}
