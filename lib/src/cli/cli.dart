import 'package:cmdline/cmdline.dart';

/// Describes the shape of a command line tool.
///
/// This is only a model: it holds the commands, flags, options and arguments
/// the tool accepts. Call [build] to get a [CLIRunner] that can parse input.
class CLI {
  final String name;
  final String description;
  final List<CLICommand> subCommands;
  final List<CLIFlag> flags;
  final List<CLIOption> options;
  final List<CLIArgument> arguments;
  final CommandRun run;

  const CLI(
    this.name, {
    required this.description,
    this.subCommands = const [],
    this.flags = const [],
    this.options = const [],
    this.arguments = const [],
    this.run = doNothing,
  });

  /// Creates a [CLIRunner] for this CLI.
  ///
  /// The top level of the CLI is turned into a root [CLICommand] that the
  /// runner parses arguments against.
  CLIRunner build() => CLIRunner(
    CLICommand(
      name: name,
      description: description,
      subCommands: subCommands,
      flags: flags,
      options: options,
      arguments: arguments,
      run: run,
    ),
  );
}
