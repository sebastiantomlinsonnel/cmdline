import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// A progress bar that fills up on one line of the terminal.
///
/// Tell it how many steps there are, move it along with [add] or [update],
/// and end it with [done] or [failed], which leave a PASS or FAIL line.
///
/// ```dart
/// final bar = ProgressBar('Copying files', total: files.length);
/// for (final file in files) {
///   await copy(file);
///   bar.add();
/// }
/// bar.done('Copied ${files.length} files');
/// ```
///
/// Shows as: `LOG   | Copying files ██████████▍         52%  13/25`
///
/// Don't print anything else while the bar is showing, or it will be split
/// over two lines.
class ProgressBar {
  /// The text shown in front of the bar.
  final String label;

  /// How many steps make 100%.
  final int total;

  /// How many characters wide the bar is.
  final int width;

  /// The colour of the filled part of the bar.
  final AsciiInk colour;

  int _current = 0;
  String _lastDrawn = '';

  /// Creates the bar and shows it straight away, empty.
  ProgressBar(
    this.label, {
    required this.total,
    this.width = 30,
    this.colour = const AsciiColour(10),
  }) {
    // Hide the cursor so it doesn't flicker over the bar.
    stdout.write(HIDE_CURSOR);
    _draw();
  }

  /// How many steps are done so far.
  int get current => _current;

  /// How much is done, from 0.0 (nothing) to 1.0 (everything).
  double get fraction {
    if (total <= 0) return 1;

    return (_current / total).clamp(0.0, 1.0);
  }

  /// Moves the bar on by [steps] (one step if left out).
  void add([int steps = 1]) => update(_current + steps);

  /// Sets how many steps are done, like `update(50)`.
  void update(int current) {
    _current = current;
    _draw();
  }

  /// Ends the bar and leaves a PASS line with [message] (or the label).
  void done([String? message]) {
    _clear();
    pass(message ?? label);
  }

  /// Ends the bar and leaves a FAIL line with [message] (or the label).
  void failed([String? message]) {
    _clear();
    fail(message ?? label);
  }

  /// Just the bar itself, [width] characters wide and [fraction] full.
  ///
  /// Use it to put a bar in your own text, like
  /// `print('Disk ${ProgressBar.bar(0.7)} 70%')`.
  static String bar(
    double fraction, {
    int width = 30,
    AsciiInk colour = const AsciiColour(10),
  }) {
    // Count in eighths of a character, so the bar grows smoothly.
    final eighths = (fraction.clamp(0.0, 1.0) * width * 8).round();
    final fullCells = eighths ~/ 8;
    final leftOver = eighths % 8;

    var filled = FULL_BLOCK * fullCells;
    if (leftOver > 0) filled += kBAR_EIGHTHS[leftOver - 1];
    final emptyCells = width - fullCells - (leftOver > 0 ? 1 : 0);

    return '${filled.foreground(colour)}${(LIGHT_SHADE * emptyCells).dim}';
  }

  /// Draws the bar on the current line, if it has changed.
  void _draw() {
    final percent = '${(fraction * 100).round()}%'.padLeft(4);
    final text =
        '$label ${bar(fraction, width: width, colour: colour)} '
        '$percent  ${'$_current/$total'.dim}';
    if (text == _lastDrawn) return;
    _lastDrawn = text;

    stdout.write('$CLEAR_LINE${Logger.instance.getString(text, Level.log)}');
  }

  /// Wipes the bar off the line and shows the cursor again.
  void _clear() => stdout.write('$CLEAR_LINE$SHOW_CURSOR');
}
