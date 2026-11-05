import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for the theme and the error and help screens the CLI builder prints.
class CliDemo {
  const CliDemo._();

  /// Shows the default theme, then the same lines with a custom theme.
  static void theme() {
    final start = CliTheme.current;
    try {
      _sample('The default theme');

      CliTheme.current = const CliTheme(
        question: AnsiColour(13),
        success: AnsiPalette.mint,
        error: AnsiPalette.brick,
        border: AnsiColour(13),
        box: BoxChars.doubleLine,
        tick: '+',
        cross: 'x',
      );
      _sample('A custom theme');
    } finally {
      CliTheme.current = start;
    }

    heading('Colour can be turned off');
    log(
      'CliTheme.useColour is ${CliTheme.useColour} here. '
      'Set NO_COLOR or pipe the output to turn it off.',
    );
  }

  /// Shows what users see when they type something wrong.
  ///
  /// [cli] is the demo's own CLI, so the errors are the real ones.
  static void errors(CLI cli) {
    for (final typed in [
      ['--nope'],
      ['-scene', '9'],
      ['logging', '-a=yes'],
    ]) {
      heading('demo ${typed.join(' ')}');
      try {
        Parser(cli, typed).parse();
        log('No error');
      } on CLIError catch (error) {
        CliTheme.say(HelpPrinter.error(error));
      }
    }
  }

  /// Prints a success line, an error line and a box in the current theme.
  static void _sample(String title) {
    final theme = CliTheme.current;
    heading(title);
    CliTheme.say(theme.successLine('A success line'));
    CliTheme.say(theme.errorLine('An error line'));
    CliTheme.say(
      CMD.draw.box('Boxes and tables follow the theme', title: title),
    );
  }
}
