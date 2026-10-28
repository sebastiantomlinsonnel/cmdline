/// A named setting that takes a value, like `--name Sam` or `-n Sam`.
///
/// Give it to a [Command] or [Cli] in their `options` list, then read it in
/// `run` with `input.option('name')`, or `input.options('name')` when
/// [multiple] is on.
///
/// The user can type the value in any of these ways:
/// `--name Sam`, `--name=Sam`, `-n Sam` or `-nSam`.
///
/// ```dart
/// Option('priority', allowed: ['low', 'high'], defaultValue: 'low')
/// ```
class Option {
  /// The long name, typed as `--name`.
  final String name;

  /// An optional one-letter name, typed as `-x`.
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
