import '../../../cmdline.dart';

/// What [Parser] found in the user's arguments.
///
/// {@category cli}
class ParseResult {
  /// The picked commands from the top down, like `[todo, add]`.
  ///
  /// The last one is the command to run.
  final List<Command> commands;

  /// The flags, options and leftover words, ready for `run`.
  final Input input;

  /// Whether the user asked for the help screen.
  final bool helpWanted;

  /// Whether the user asked for the version.
  final bool versionWanted;

  /// Creates a result. Normally only [Parser] does this.
  const ParseResult({
    required this.commands,
    required this.input,
    required this.helpWanted,
    required this.versionWanted,
  });

  /// The command the user picked, which is the one to run.
  Command get command => commands.last;
}
