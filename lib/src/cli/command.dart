import 'dart:async';

import 'package:cmdline/cmdline.dart';

/// The function a command calls when the user picks it.
///
/// It gets an [Input] with everything the user typed. It can be `async`.
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
class Command {
  /// The word the user types to pick this command.
  final String name;

  /// One line explaining the command, shown in the help screen.
  final String about;

  /// Other words that also pick this command, like `ls` for `list`.
  final List<String> aliases;

  /// The on/off switches this command understands.
  final List<Flag> flags;

  /// The settings with values this command understands.
  final List<Option> options;

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
  /// name, or a short name isn't exactly one letter.
  Command({
    required this.name,
    this.about = '',
    this.aliases = const [],
    this.flags = const [],
    this.options = const [],
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

  /// Throws if two parts of this command share a name.
  void _checkNames() {
    final seen = <String>{};

    for (final flag in flags) {
      _claim(seen, '--${flag.name}');
      _claimShort(seen, flag.short);
    }
    for (final option in options) {
      _claim(seen, '--${option.name}');
      _claimShort(seen, option.short);
    }
    for (final command in commands) {
      _claim(seen, command.name);
      for (final alias in command.aliases) {
        _claim(seen, alias);
      }
    }
  }

  /// Checks a one-letter name and adds it to [seen].
  void _claimShort(Set<String> seen, String? short) {
    if (short == null) return;
    if (short.length != 1) {
      throw ArgumentError('Short name "$short" in "$name" must be one letter.');
    }
    _claim(seen, '-$short');
  }

  /// Adds [label] to [seen], or throws if it is already there.
  void _claim(Set<String> seen, String label) {
    if (!seen.add(label)) {
      throw ArgumentError('"$name" has two things called "$label".');
    }
  }
}
