/// A mistake the user made when typing the command.
///
/// Thrown by [Parser] for things like an unknown option, a missing value or a
/// missing required option. [CLI.start] catches it and prints it nicely, so
/// you normally never see it yourself.
///
/// {@category cli}
class CLIError implements Exception {
  /// What went wrong, written for the user.
  final String message;

  /// The command the user was in when it went wrong, like `['todo', 'add']`.
  ///
  /// Used to suggest the right `--help` command.
  final List<String> commandPath;

  /// Creates an error with a [message] for the user.
  const CLIError(this.message, this.commandPath);

  @override
  String toString() => message;
}
