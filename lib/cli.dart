/// Complete versatile CLI builder
library cli;

import 'dart:io';

import 'package:cmdline/cmdline.dart';

export 'cli.dart';
export 'src/cli/cli_error.dart';
export 'src/cli/command.dart';
export 'src/cli/parser/arguments.dart';
export 'src/cli/parser/input.dart';
export 'src/cli/parser/parser.dart';
export 'src/cli/parser/parser_result.dart';
export 'src/cli/theme/cli_theme.dart';
export 'src/cli/theme/help.dart';

/// The whole program: the top command plus a version and a [start] method.
///
/// A [CLI] is a [Command], so it takes the same `flags`, `options`,
/// `commands` and `run`. Flags and options given here work in every
/// sub-command as well.
///
/// ```dart
/// final cli = CLI(
///   name: 'todo',
///   about: 'A tiny todo app',
///   version: '1.0.0',
///   commands: [Command(name: 'list', run: (input) => print('Nothing yet'))],
/// );
///
/// void main(List<String> arguments) => cli.start(arguments);
/// ```
class CLI extends Command {
  /// The version shown by `--version` and at the top of the help screen.
  ///
  /// When left out, `--version` isn't available.
  final String? version;

  /// The `--verbose` / `-v` flag every [CLI] gets for free.
  ///
  /// Read it with `input.verbose`. When the user types it, dev and debug
  /// log messages are shown. Declare your own `verbose` flag to replace it.
  static const Flag verboseFlag = Flag(
    'verbose',
    short: 'v',
    help: 'Show extra detail',
  );

  /// Creates the program.
  CLI({
    required super.name,
    super.help,
    this.version,
    super.flags,
    super.options,
    super.arguments,
    super.commands,
    super.run,
  });

  /// Reads what the user typed and runs the matching command.
  ///
  /// Also handles `--help`, `--version` and mistakes for you:
  /// * `--help` or `-h` prints the help screen of the picked command.
  /// * `--version` prints [name] and [version].
  /// * A mistake prints a red error and sets the exit code to 64.
  /// * A command without a `run` function prints its help screen.
  Future<void> start(List<String> args) async {
    final ParseResult result;
    try {
      result = Parser(this, args).parse();
    } on CLIError catch (error) {
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
