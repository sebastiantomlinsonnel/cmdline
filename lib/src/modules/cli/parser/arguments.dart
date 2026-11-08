/// A plain word the user types without a dash, like `c` in `run to c`.
///
/// Give it to a [Command] in its `arguments` list, then read it in `run` with
/// `input.argument('key')`. Words are matched to arguments in order, so the
/// first plain word goes to the first argument, and so on.
///
/// ```dart
/// Argument('key', help: 'The saved key, like "c"')
/// ```
///
/// {@category cli}
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

/// An on/off switch, like `--verbose` or `-v`.
///
/// A flag is `false` unless the user types it. Give it to a [Command] or [CLI]
/// in their `flags` list, then read it in `run` with `input.flag('verbose')`.
///
/// ```dart
/// Flag('verbose', short: 'v', help: 'Print extra detail')
/// ```
///
/// {@category cli}
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

/// A named setting that takes a value, like `--name Sam` or `-n Sam`.
///
/// Give it to a [Command] or [CLI] in their `options` list, then read it in
/// `run` with `input.option('name')`, or `input.options('name')` when
/// [multiple] is on.
///
/// Options always use one dash, so the user can type the value in any of
/// these ways: `-name Sam`, `-name=Sam` or `-N Sam`.
///
/// ```dart
/// Option('priority', short: 'P', allowed: ['low', 'high'], defaultValue: 'low')
/// ```
///
/// {@category cli}
class Option {
  /// The long name, typed with one dash as `-name`.
  ///
  /// Must be lowercase and at least two characters.
  final String name;

  /// An optional short name: one capital letter, typed as `-X`.
  ///
  /// Capital means option; lowercase is kept for flags.
  final String? short;

  /// One line explaining the option, shown in the help screen.
  final String help;

  /// The word shown for the value in the help screen, like `<file>`.
  ///
  /// When left out, [name] is used.
  final String? valueName;

  /// The value used when the user doesn't type the option.
  final String? defaultValue;

  /// The only values the user may type.
  ///
  /// Empty means any value is fine.
  final List<String> allowed;

  /// Whether the user must type this option.
  ///
  /// When it is missing, an error is shown and `run` is not called.
  final bool required;

  /// Whether the option can be typed more than once.
  ///
  /// `--tag a --tag b` gives `['a', 'b']` from `input.options('tag')`.
  /// Without this, a second value replaces the first.
  final bool multiple;

  /// Whether to leave the option out of the help screen.
  ///
  /// It still works when typed.
  final bool hidden;

  /// Creates an option called [name].
  const Option(
    this.name, {
    this.short,
    this.help = '',
    this.valueName,
    this.defaultValue,
    this.allowed = const [],
    this.required = false,
    this.multiple = false,
    this.hidden = false,
  });
}
