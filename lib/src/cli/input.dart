/// Everything the user typed, ready to read inside a command's `run`.
///
/// Flags and options from parent commands can be read here too, so a
/// `--verbose` flag on the [Cli] works inside every sub-command.
///
/// Asking for a name that was never declared throws an [ArgumentError], so
/// spelling mistakes in your own code show up straight away.
class Input {
  final Map<String, bool> _flags;
  final Map<String, List<String>> _options;
  final Set<String> _given;

  /// Words that weren't flags, options or commands, like file names.
  ///
  /// Everything after `--` also ends up here, even if it starts with `-`.
  final List<String> rest;

  /// The names of the commands that were picked, like `['todo', 'add']`.
  final List<String> commandPath;

  /// Creates the input. Normally only [Parser] does this.
  Input({
    required Map<String, bool> flags,
    required Map<String, List<String>> options,
    required Set<String> given,
    required this.rest,
    required this.commandPath,
  }) : _flags = flags,
       _options = options,
       _given = given;

  /// Whether the flag called [name] is on.
  bool flag(String name) {
    final value = _flags[name];
    if (value == null) {
      throw ArgumentError('There is no flag called "$name".');
    }

    return value;
  }

  /// The value of the option called [name], or `null` if it has none.
  ///
  /// If the option was typed more than once, this is the last value.
  String? option(String name) {
    final values = options(name);

    return values.isEmpty ? null : values.last;
  }

  /// Every value given for the option called [name].
  ///
  /// Meant for options with `multiple: true`. Empty if none were given.
  List<String> options(String name) {
    final values = _options[name];
    if (values == null) {
      throw ArgumentError('There is no option called "$name".');
    }

    return List.unmodifiable(values);
  }

  /// Whether the user typed `--verbose` (or `-v`).
  ///
  /// Every [Cli] has this flag, so it is always safe to read.
  bool get verbose => flag('verbose');

  /// Whether the user typed the flag or option called [name] themselves.
  ///
  /// Useful to tell a typed value apart from a default.
  bool wasGiven(String name) => _given.contains(name);
}
