import 'dart:async';

import 'package:cmdline/cmdline.dart';

/// Called when a command runs.
///
/// [flags] maps each flag name to its value. [options] maps each option name
/// to its values: one value normally, several for a [CLIOption.multiple]
/// option, or none when it was not given and has no default.
typedef CommandRun = FutureOr<void> Function(
  Map<String, bool> flags,
  Map<String, List<String>> options,
);

class CLICommand {
  final String name;
  final String description;

  /// Leave as [doNothing] for a pure group command.
  final CommandRun run;
  final List<String> aliases;
  final bool hidden;
  final List<CLICommand> subCommands;
  final List<CLIFlag> flags;
  final List<CLIOption> options;
  final List<CLIArgument> arguments;

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
