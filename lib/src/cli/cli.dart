import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Called when a command runs. Receives everything that was parsed.
typedef CliRun = FutureOr<void> Function(CLIResult result);

class CLI {
  final String name;
  final String description;
  final List<CLICommand> subCommands;
  final List<CLIFlag> flags;
  final List<CLIOption> options;
  final List<CLIArgument> arguments;
  final CliRun run;

  const CLI(
    this.subCommands, {
    this.name = 'cli',
    this.description = '',
    this.flags = const [],
    this.options = const [],
    this.arguments = const [],
    this.run = doNothing,
  });

  /// Parses [args], runs the matching command and returns an exit code.
  Future<int> execute(List<String> args) async {
    final root = CLICommand(
      name: name,
      description: description,
      subCommands: subCommands,
      flags: flags,
      options: options,
      arguments: arguments,
      run: run,
    );
    final parser = Parser(root);
    try {
      final result = parser.parse(args);
      if (result == null) {
        stdout.writeln(parser.usage());
        return 0;
      }
      await parser.command.run(result);
      return 0;
    } on CLIException catch (e) {
      stderr
        ..writeln('Error: ${e.message}')
        ..writeln()
        ..writeln(parser.usage());
      return 64;
    }
  }
}
