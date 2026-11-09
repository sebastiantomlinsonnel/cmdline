import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

/// Prompts for crafting CLIs
class Prompts {
  const Prompts._();

  /// Asks the user a question and gives back what they type.
  ///
  /// The question is drawn with [AnsiTheme.current]. A wrong answer shows an
  /// error line and asks again.
  ///
  /// * [defaultValue]: used when the user just presses Enter. Shown dim after
  ///   the question.
  /// * [hidden]: don't show what is typed, for passwords.
  /// * [required]: an empty answer isn't allowed (unless there's a default).
  /// * [validator]: gives back a problem to show, or null if the answer is ok.
  ///
  /// ```dart
  /// final name = ask('Project name', defaultValue: 'my_app');
  /// final port = ask('Port', validator: (a) =>
  ///     int.tryParse(a) == null ? 'Type a number' : null);
  /// final secret = ask('Password', hidden: true);
  /// ```
  static String ask(
    String prompt, {
    String? defaultValue,
    bool hidden = false,
    bool required = true,
    String? Function(String answer)? validator,
  }) {
    return PromptLine.run<String>(
      prompt,
      hint: defaultValue == null || hidden ? '' : '($defaultValue)',
      hidden: hidden,
      shown: (answer) => hidden ? BULLET * answer.length : answer,
      check: (typed) {
        final answer = typed.isEmpty ? defaultValue ?? '' : typed;
        final problem = answer.isEmpty && required
            ? 'An answer is needed'
            : validator?.call(answer);

        return (value: answer, problem: problem);
      },
    );
  }

  /// Asks a yes or no question and gives back true for yes.
  ///
  /// A dim `[Y/n]` hint shows which answer Enter picks when there is a
  /// [defaultValue]; without one, the user must type y or n.
  ///
  /// ```dart
  /// if (confirm('Delete the build folder?', defaultValue: false)) {
  ///   deleteDir('build');
  /// }
  /// ```
  static bool confirm(String prompt, {bool? defaultValue}) {
    final hint = switch (defaultValue) {
      true => '[Y/n]',
      false => '[y/N]',
      null => '[y/n]',
    };

    return PromptLine.run<bool>(
      prompt,
      hint: hint,
      shown: (yes) => yes ? 'Yes' : 'No',
      check: (typed) {
        final answer = switch (typed.toLowerCase()) {
          'y' || 'yes' => true,
          'n' || 'no' => false,
          '' => defaultValue,
          _ => null,
        };

        return (
          value: answer,
          problem: answer == null ? 'Please type y or n' : null,
        );
      },
    );
  }

  /// Lets the user pick one of [options] and gives back the one they picked.
  ///
  /// In a terminal, the options are a list you move through with the arrow
  /// keys (or `j`/`k`), and pick with Enter. Number keys jump straight to an
  /// option. The current row shows the theme's pointer in its highlight
  /// colour. When there's no terminal (or colour is off) it falls back to a
  /// numbered list and asks for a number.
  ///
  /// * [format]: how each option is shown. Defaults to `toString()`.
  /// * [defaultOption]: the option picked at the start.
  ///
  /// ```dart
  /// final colour = menu('Pick a colour', ['Red', 'Green', 'Blue']);
  /// final file = menu('Open which file?', files, format: basename);
  /// ```
  static T menu<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    T? defaultOption,
  }) {
    if (options.isEmpty) throw ArgumentError.value(options, 'options', 'Empty');

    final labels = [
      for (final option in options) format?.call(option) ?? '$option',
    ];
    final start = math.max(
      defaultOption == null ? 0 : options.indexOf(defaultOption),
      0,
    );

    final interactive =
        AnsiTheme.useColour && stdin.hasTerminal && stdout.hasTerminal;
    final picked = interactive
        ? _MenuScreen(prompt, labels, start).run()
        : _numberedMenu(prompt, labels, start);

    return options[picked];
  }

  /// Prints the options as a numbered list and asks for a number.
  static int _numberedMenu(String prompt, List<String> labels, int start) {
    final theme = AnsiTheme.current;
    AnsiTheme.say(
      '${'?'.foreground(theme.hint)} '
      '${prompt.bold.foreground(theme.question)}',
    );
    for (var i = 0; i < labels.length; i++) {
      AnsiTheme.say('  ${'${i + 1})'.foreground(theme.hint)} ${labels[i]}');
    }

    final number = PromptLine.run<int>(
      'Number',
      hint: '(${start + 1})',
      shown: (index) => labels[index],
      check: (typed) {
        if (typed.isEmpty) return (value: start, problem: null);
        final index = (int.tryParse(typed) ?? 0) - 1;
        final ok = index >= 0 && index < labels.length;

        return (
          value: ok ? index : null,
          problem: ok ? null : 'Type a number from 1 to ${labels.length}',
        );
      },
    );

    return number;
  }
}

/// The arrow-key menu, drawn and redrawn in place.
class _MenuScreen {
  final String prompt;
  final List<String> labels;
  int selected;

  /// The first option shown, when there are more options than fit.
  int _top = 0;

  /// How many option rows were drawn last time, to move back over them.
  int _drawnRows = 0;

  /// The option a number key picked, counting from 0.
  int _number = 0;

  _MenuScreen(this.prompt, this.labels, this.selected);

  /// How many options fit on screen at once.
  int get _pageSize {
    final rows = stdout.hasTerminal ? stdout.terminalLines : 24;

    return math.min(labels.length, math.max(rows - 2, 3));
  }

  /// Shows the menu, reads keys until Enter, and gives back the picked index.
  int run() {
    final theme = AnsiTheme.current;
    final question = prompt.bold.foreground(theme.question);
    stdout.write(
      '${'?'.foreground(theme.hint)} $question '
      '${'(↑/↓ and Enter)'.dim.foreground(theme.hint)}\n$HIDE_CURSOR',
    );

    final echo = stdin.echoMode;
    final line = stdin.lineMode;
    // Windows needs echo off before line mode can be turned off.
    stdin
      ..echoMode = false
      ..lineMode = false;
    try {
      _draw();
      while (true) {
        final key = _readKey();
        if (key == _Key.enter) break;
        if (key == _Key.cancel) {
          _restore(echo, line);
          exit(130);
        }
        if (key == _Key.up) selected = (selected - 1) % labels.length;
        if (key == _Key.down) selected = (selected + 1) % labels.length;
        if (key == _Key.number && _number < labels.length) selected = _number;
        _draw();
      }
    } finally {
      _restore(echo, line);
    }

    // Swap the whole menu for one line with the answer.
    final done =
        '${theme.tick.foreground(theme.success)} $question '
        '${labels[selected].plain.foreground(theme.answer)}';
    stdout.write('${cursorUp(_drawnRows + 1)}\r$CLEAR_TO_SCREEN_END$done\n');

    return selected;
  }

  /// Draws the visible options, replacing the ones drawn before.
  void _draw() {
    final theme = AnsiTheme.current;
    final page = _pageSize;
    if (selected < _top) _top = selected;
    if (selected >= _top + page) _top = selected - page + 1;

    final width = stdout.hasTerminal ? stdout.terminalColumns - 4 : 76;
    final out = StringBuffer(SYNC_START);
    if (_drawnRows > 0) out.write('${cursorUp(_drawnRows)}\r');
    out.write(CLEAR_TO_SCREEN_END);

    for (var i = _top; i < _top + page; i++) {
      final label = _fit(labels[i], width);
      if (i == selected) {
        out.write(
          '${'${theme.pointer} $label'.bold.foreground(theme.highlight)}\n',
        );
      } else {
        out.write('  $label$RESET\n');
      }
    }
    out.write(SYNC_END);
    _drawnRows = page;
    stdout.write(out);
  }

  /// [label] cut down to [width] visible characters, ending in an ellipsis.
  ///
  /// The length is measured without escape codes, so styled labels aren't
  /// cut short. A label that needs cutting loses its styles.
  String _fit(String label, int width) {
    final plain = label.plain;
    if (plain.length <= width || width < 2) return label;

    return '${plain.substring(0, width - 1)}$ELLIPSIS';
  }

  /// Puts the terminal back the way it was and shows the cursor.
  void _restore(bool echo, bool line) {
    // Line mode must come back before echo on Windows.
    stdin
      ..lineMode = line
      ..echoMode = echo;
    stdout.write(SHOW_CURSOR);
  }

  /// Reads one key press and works out what it means.
  _Key _readKey() {
    final byte = stdin.readByteSync();
    switch (byte) {
      case -1 || 3:
        // Input closed, or Ctrl+C.
        return _Key.cancel;
      case 10 || 13:
        return _Key.enter;
      case 27:
        // ESC [ A is up and ESC [ B is down (ESC O A/B on some terminals).
        final second = stdin.readByteSync();
        if (second != 0x5B && second != 0x4F) return _Key.other;

        return _arrow(stdin.readByteSync(), up: 0x41, down: 0x42);
      case 0 || 0xE0:
        // Older Windows consoles send 0xE0 then H for up or P for down.
        return _arrow(stdin.readByteSync(), up: 0x48, down: 0x50);
      case 0x6B || 0x77:
        // k or w
        return _Key.up;
      case 0x6A || 0x73:
        // j or s
        return _Key.down;
      case final digit when digit >= 0x31 && digit <= 0x39:
        _number = digit - 0x31;

        return _Key.number;
      default:
        return _Key.other;
    }
  }

  /// Up, down or nothing, depending on whether [byte] is [up] or [down].
  _Key _arrow(int byte, {required int up, required int down}) {
    if (byte == up) return _Key.up;
    if (byte == down) return _Key.down;

    return _Key.other;
  }
}

/// A key press the menu cares about.

enum _Key { up, down, enter, cancel, number, other }

/// What a prompt's check makes of the typed text.
///
/// Either a `value` to give back, or a `problem` to show before asking again.
typedef PromptCheck<T> = ({T? value, String? problem}) Function(String typed);

/// Asks one question on one line until the answer passes a check.
///
/// Used by `ask`, `confirm` and the plain `menu` from [CMD.prompt]. With
/// colour on, a wrong answer shows a themed error line under the question,
/// and the question is redrawn in place. Once answered, the line is redrawn
/// with a tick and the answer in the theme's answer colour.
class PromptLine {
  const PromptLine._();

  /// Shows [question] (with an optional dim [hint]) until [check] accepts.
  ///
  /// [shown] turns the accepted value into the text echoed after the
  /// question. With [hidden], typing isn't shown on screen. If input ends
  /// (stdin is closed), [check] gets an empty string, and if that isn't
  /// accepted a [StdinException] is thrown.
  static T run<T>(
    String question, {
    required PromptCheck<T> check,
    required String Function(T value) shown,
    String hint = '',
    bool hidden = false,
  }) {
    final theme = AnsiTheme.current;
    final fancy = AnsiTheme.useColour && stdout.hasTerminal;
    final text = question.bold.foreground(theme.question);
    final hintText = hint.isEmpty ? '' : ' ${hint.dim.foreground(theme.hint)}';
    final asked = '${'?'.foreground(theme.hint)} $text$hintText ';

    var showingProblem = false;
    while (true) {
      AnsiTheme.write(asked);
      final typed = _readLine(hidden: hidden);
      final result = check(typed?.trim() ?? '');

      // Wipe the old error line under the question.
      if (fancy && showingProblem) stdout.write('\r$CLEAR_TO_SCREEN_END');

      final value = result.value;
      if (result.problem == null && value is T) {
        if (fancy) {
          final done =
              '${theme.tick.foreground(theme.success)} $text '
              '${shown(value).foreground(theme.answer)}';
          stdout.write('${cursorUp()}\r$CLEAR_LINE$done$RESET\n');
        }

        return value;
      }
      if (typed == null) {
        throw const StdinException('Input ended before an answer was given');
      }

      final problem = theme.errorLine(result.problem ?? 'Try again');
      if (fancy) {
        // Show the error under the question, then go back up to ask again.
        stdout.write('$problem${cursorUp()}\r$CLEAR_LINE');
        showingProblem = true;
      } else {
        AnsiTheme.say(problem);
      }
    }
  }

  /// Reads one line from stdin, hiding what is typed if [hidden] is true.
  ///
  /// Gives back null when stdin has closed.
  static String? _readLine({required bool hidden}) {
    if (!hidden || !stdin.hasTerminal) return stdin.readLineSync();

    final echo = stdin.echoMode;
    stdin.echoMode = false;
    try {
      return stdin.readLineSync();
    } finally {
      stdin.echoMode = echo;
      // Enter wasn't shown either, so move to the next line ourselves.
      stdout.writeln();
    }
  }
}
