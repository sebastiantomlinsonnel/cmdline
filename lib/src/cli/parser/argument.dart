/// A plain word the user types without a dash, like `c` in `run to c`.
///
/// Give it to a [Command] in its `arguments` list, then read it in `run` with
/// `input.argument('key')`. Words are matched to arguments in order, so the
/// first plain word goes to the first argument, and so on.
///
/// ```dart
/// Argument('key', help: 'The saved key, like "c"')
/// ```
class Argument {
  /// The name shown in the help screen as `<name>`.
  ///
  /// Also the name you read it with: `input.argument(name)`.
  final String name;

  /// One line explaining the argument, shown in the help screen.
  final String help;

  /// Whether the user must type this argument.
  ///
  /// When it is missing, an error is shown and `run` is not called. Optional
  /// arguments must come after required ones.
  final bool required;

  /// Creates an argument called [name].
  const Argument(this.name, {this.help = '', this.required = true});
}
