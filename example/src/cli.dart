import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for the theme and the error and help screens the CLI builder prints.
class CliDemo {
  const CliDemo._();

  /// Shows the default theme, then the same lines with a custom theme.
  static void theme() {
    final start = AnsiTheme.current;
    try {
      _sample('The default theme');

      AnsiTheme.current = const AnsiTheme(
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
      AnsiTheme.current = start;
    }

    heading('Colour can be turned off');
    log(
      'AnsiTheme.useColour is ${AnsiTheme.useColour} here. '
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
        AnsiTheme.say(HelpPrinter.error(error));
      }
    }
  }

  /// Prints a success line, an error line and a box in the current theme.
  static void _sample(String title) {
    final theme = AnsiTheme.current;
    heading(title);
    AnsiTheme.say(theme.successLine('A success line'));
    AnsiTheme.say(theme.errorLine('An error line'));
    AnsiTheme.say(
      Widgets.box('Boxes and tables follow the theme', title: title),
    );
  }
}
