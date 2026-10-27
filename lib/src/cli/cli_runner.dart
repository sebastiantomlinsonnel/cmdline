import 'package:cmdline/cmdline.dart';

/// Parses command line arguments against a built [CLI].
///
/// Get one from [CLI.build]. Each call to [parse] starts fresh, so a runner
/// can be reused for many argument lists.
class CLIRunner {
  /// The top level command made from the [CLI].
  final CLICommand root;

  Parser _parser;

  CLIRunner(this.root) : _parser = Parser(root);

  /// Parses [args] and returns the command they selected.
  ///
  /// The returned [CLIResult] holds the matched [CLIResult.command] along with
  /// its parsed flags, options and arguments. Returns null when help should be
  /// shown instead (`--help`, or a group command with no sub command chosen);
  /// use [usage] to get the help text. Throws [CLIException] on bad input.
  CLIResult? parse(List<String> args) {
    _parser = Parser(root);
    return _parser.parse(args);
  }

  /// Help text for the command reached by the last [parse].
  ///
  /// Before any parse, this is the help for the root command.
  String usage() => _parser.usage();
}
