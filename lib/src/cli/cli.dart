import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Which dashes the user types for flags and options.
enum DashStyle {
  /// The usual style: `--word` for long names and `-x` for one letter.
  ///
  /// Works the same for flags and options, and allows grouping like `-abc`
  /// and glued values like `-tBuy`.
  classic,

  /// Flags always use `--` and options always use `-`.
  ///
  /// `--urgent` is always a flag and `-text Buy` is always an option, so the
  /// dash tells you which kind it is. Short names work too (`--u`, `-t`), but
  /// grouping and glued values don't. Using the wrong dash shows a hint.
  split,
}

/// The whole program: the top command plus a version and a [start] method.
///
/// A [Cli] is a [Command], so it takes the same `flags`, `options`,
/// `commands` and `run`. Flags and options given here work in every
/// sub-command as well.
///
/// ```dart
/// final cli = Cli(
///   name: 'todo',
///   about: 'A tiny todo app',
///   version: '1.0.0',
///   commands: [Command(name: 'list', run: (input) => print('Nothing yet'))],
/// );
///
/// void main(List<String> arguments) => cli.start(arguments);
/// ```
class Cli extends Command {
  /// The version shown by `--version` and at the top of the help screen.
  ///
  /// When left out, `--version` isn't available.
  final String? version;

  /// Which dashes the user types for flags and options.
  ///
  /// [DashStyle.classic] by default.
  final DashStyle dashes;

  /// Whether options must use capital short names and flags lowercase ones.
  ///
  /// With this on, `-T` is always an option and `-u` is always a flag, so
  /// they're easy to tell apart. It is checked for every command when the
  /// [Cli] is built.
  final bool capitalOptions;

  /// Creates the program.
  ///
  /// Throws an [ArgumentError] if [capitalOptions] is on and a short name
  /// has the wrong case.
  Cli({
    required super.name,
    super.about,
    this.version,
    this.dashes = DashStyle.classic,
    this.capitalOptions = false,
    super.flags,
    super.options,
    super.commands,
    super.run,
  }) {
    if (capitalOptions) _checkCapitals(this);
  }

  /// Checks the short-name case rule for [command] and everything inside it.
  void _checkCapitals(Command command) {
    for (final flag in command.flags) {
      final short = flag.short;
      if (short != null && short != short.toLowerCase()) {
        throw ArgumentError(
          'The flag "${flag.name}" needs a lowercase short name, '
          'because capitalOptions is on.',
        );
      }
    }

    for (final option in command.options) {
      final short = option.short;
      // A capital letter changes when lowercased; digits and symbols don't.
      if (short != null && short == short.toLowerCase()) {
        throw ArgumentError(
          'The option "${option.name}" needs a capital short name, '
          'because capitalOptions is on.',
        );
      }
    }

    for (final sub in command.commands) {
      _checkCapitals(sub);
    }
  }

  /// Reads what the user typed and runs the matching command.
  ///
  /// Also handles `--help`, `--version` and mistakes for you:
  /// * `--help` or `-h` prints the help screen of the picked command.
  /// * `--version` prints [name] and [version].
  /// * A mistake prints a red error and sets the exit code to 64.
  /// * A command without a `run` function prints its help screen.
  Future<void> start(List<String> arguments) async {
    final ParseResult result;
    try {
      result = Parser(this, arguments).parse();
    } on CliError catch (error) {
      stderr.writeln(HelpPrinter.error(error));
      exitCode = 64;

      return;
    }

    if (result.versionWanted) {
      stdout.writeln('$name $version');

      return;
    }

    final run = result.command.run;
    if (result.helpWanted || run == null) {
      stdout.writeln(HelpPrinter(result.commands).build());

      return;
    }

    await run(result.input);
  }
}
