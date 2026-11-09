import 'dart:io';

import 'terminal.dart';

/// How prompts get their answers.
///
/// Picked by [PromptMode.current], which looks at the terminal unless it is
/// set by hand or with the `CMDLINE_PROMPTS` environment variable (`rich`,
/// `line` or `unattended`).
///
/// {@category cli}
enum PromptMode {
  /// Live, redrawn widgets driven by single key presses. Needs a real
  /// keyboard and a screen that understands escape codes.
  rich,

  /// One question per line, answered by typing and pressing Enter. Used when
  /// input is piped in, or the screen can't move the cursor.
  line,

  /// No questions at all: every prompt takes its default, and a prompt
  /// without one throws `PromptCancelled`. Used in CI.
  unattended;

  static PromptMode? _override;

  /// The mode prompts use right now. Set it to force one; set null to go
  /// back to detecting it.
  static PromptMode get current => _override ?? detect();

  static set current(PromptMode? mode) => _override = mode;

  /// The mode set by hand, or null when it is detected.
  static PromptMode? get forced => _override;

  /// Works out the mode from the environment and [Terminal.current].
  ///
  /// * `CMDLINE_PROMPTS` set to a mode name wins.
  /// * A keyboard and an escape-code screen give [rich].
  /// * No keyboard while `CI` is set gives [unattended].
  /// * Anything else gives [line].
  static PromptMode detect() {
    final env = Platform.environment;
    final named = env['CMDLINE_PROMPTS']?.toLowerCase();
    for (final mode in values) {
      if (mode.name == named) return mode;
    }

    final terminal = Terminal.current;
    if (terminal.hasInput && terminal.supportsAnsi) return rich;
    final ci = (env['CI'] ?? '').toLowerCase();
    if (!terminal.hasInput && ci.isNotEmpty && ci != 'false' && ci != '0') {
      return unattended;
    }

    return line;
  }
}
