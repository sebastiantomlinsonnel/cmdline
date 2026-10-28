/// An on/off switch, like `--verbose` or `-v`.
///
/// A flag is `false` unless the user types it. Give it to a [Command] or [Cli]
/// in their `flags` list, then read it in `run` with `input.flag('verbose')`.
///
/// ```dart
/// Flag('verbose', short: 'v', help: 'Print extra detail')
/// ```
class Flag {
  /// The long name, typed with two dashes as `--name`.
  ///
  /// Must be lowercase and at least two characters.
  final String name;

  /// An optional short name: one lowercase letter, typed as `-x`.
  ///
  /// Lowercase means flag; capitals are kept for options.
  final String? short;

  /// One line explaining the flag, shown in the help screen.
  final String help;

  /// The value used when the user doesn't type the flag.
  final bool defaultValue;

  /// Whether `--no-name` is allowed to turn the flag off.
  ///
  /// Mostly useful together with `defaultValue: true`.
  final bool negatable;

  /// Whether to leave the flag out of the help screen.
  ///
  /// It still works when typed.
  final bool hidden;

  /// Creates a flag called [name].
  const Flag(
    this.name, {
    this.short,
    this.help = '',
    this.defaultValue = false,
    this.negatable = false,
    this.hidden = false,
  });
}
