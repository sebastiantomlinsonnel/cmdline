import 'dart:async';

import '../../../cmdline.dart';

/// The function a command calls when the user picks it.
///
/// It gets an [Input] with everything the user typed. It can be `async`.
///
/// {@category cli}
typedef RunCommand = FutureOr<void> Function(Input input);

/// One thing your program can do, like `add` in `todo add`.
///
/// A command has its own [flags], [options] and [run] function. It can also
/// hold more [commands] inside it, so `git remote add` style tools are just
/// commands inside commands.
///
/// ```dart
/// Command(
///   name: 'add',
///   about: 'Add a task',
///   options: [Option('text', short: 't', required: true)],
///   run: (input) => print(input.option('text')),
/// )
/// ```
///
/// {@category cli}
class Command {
  /// The word the user types to pick this command.
  final String name;

  /// One line explaining the command, shown in the help screen.
  final String help;

  /// Other words that also pick this command, like `ls` for `list`.
  final List<String> aliases;

  /// The on/off switches this command understands.
  final List<Flag> flags;

  /// The settings with values this command understands.
  final List<Option> options;

  /// The plain words this command expects, like `c` in `run to c`.
  final List<Argument> arguments;

  /// Commands inside this one, like `add` inside `todo`.
  final List<Command> commands;

  /// What to do when the user picks this command.
  ///
  /// When left out, the help screen is shown instead.
  final RunCommand? run;

  /// Whether to leave the command out of the help screen.
  ///
  /// It still works when typed.
  final bool hidden;

  /// Creates a command and checks that no two parts share a name.
  ///
  /// Throws an [ArgumentError] if two flags, options or commands use the same
  /// name, or a name breaks the dash rules (see [Flag] and [Option]).
  Command({
    required this.name,
    this.help = '',
    this.aliases = const [],
    this.flags = const [],
    this.options = const [],
    this.arguments = const [],
    this.commands = const [],
    this.run,
    this.hidden = false,
  }) {
    _checkNames();
  }

  /// Finds the flag with the long [name], or returns `null`.
  Flag? findFlag(String name) {
    for (final flag in flags) {
      if (flag.name == name) return flag;
    }

    return null;
  }

  /// Finds the flag with the one-letter [short] name, or returns `null`.
  Flag? findFlagByShort(String short) {
    for (final flag in flags) {
      if (flag.short == short) return flag;
    }

    return null;
  }

  /// Finds the option with the long [name], or returns `null`.
  Option? findOption(String name) {
    for (final option in options) {
      if (option.name == name) return option;
    }

    return null;
  }

  /// Finds the option with the one-letter [short] name, or returns `null`.
  Option? findOptionByShort(String short) {
    for (final option in options) {
      if (option.short == short) return option;
    }

    return null;
  }

  /// Finds the sub-command called [word] (or with [word] as an alias).
  ///
  /// Returns `null` when there isn't one.
  Command? findCommand(String word) {
    for (final command in commands) {
      if (command.name == word || command.aliases.contains(word)) {
        return command;
      }
    }

    return null;
  }

  /// Throws if a name breaks the rules or two parts share a name.
  ///
  /// The rules:
  /// * flags: long `--urgent`, short is one lowercase letter `-u`
  /// * options: long `-text`, short is one capital letter `-T`
  /// * long names are lowercase and at least two characters
  void _checkNames() {
    final seen = <String>{};

    for (final flag in flags) {
      _checkLongName(flag.name);
      _claim(seen, '--${flag.name}');

      final short = flag.short;
      if (short != null) {
        if (!_isLetter(short) || short != short.toLowerCase()) {
          throw ArgumentError(
            'The flag "${flag.name}" needs one lowercase letter as its short '
            'name, like "u".',
          );
        }
        _claim(seen, '-$short');
      }
    }

    for (final option in options) {
      _checkLongName(option.name);
      _claim(seen, '-${option.name}');

      final short = option.short;
      if (short != null) {
        if (!_isLetter(short) || short != short.toUpperCase()) {
          throw ArgumentError(
            'The option "${option.name}" needs one capital letter as its '
            'short name, like "T".',
          );
        }
        _claim(seen, '-$short');
      }
    }

    var sawOptional = false;
    for (final argument in arguments) {
      _claim(seen, '<${argument.name}>');

      if (!argument.required) {
        sawOptional = true;
      } else if (sawOptional) {
        throw ArgumentError(
          'The argument "${argument.name}" in "$name" is required, so it must '
          'come before the optional ones.',
        );
      }
    }

    for (final command in commands) {
      _claim(seen, command.name);
      for (final alias in command.aliases) {
        _claim(seen, alias);
      }
    }
  }

  /// Throws if [longName] isn't lowercase or is shorter than two characters.
  ///
  /// One-character names are kept for short names, so `-t` and `-text` can
  /// never be mixed up.
  void _checkLongName(String longName) {
    if (longName.length < 2 || longName != longName.toLowerCase()) {
      throw ArgumentError(
        '"$longName" in "$name" must be lowercase and at least two '
        'characters long.',
      );
    }
  }

  /// Whether [text] is exactly one letter.
  ///
  /// Letters change between upper and lower case; digits and symbols don't.
  bool _isLetter(String text) =>
      text.length == 1 && text.toLowerCase() != text.toUpperCase();

  /// Adds [label] to [seen], or throws if it is already there.
  void _claim(Set<String> seen, String label) {
    if (!seen.add(label)) {
      throw ArgumentError('"$name" has two things called "$label".');
    }
  }
}
