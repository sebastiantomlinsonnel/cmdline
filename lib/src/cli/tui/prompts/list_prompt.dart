import '../../../../cmdline.dart';

/// The shared part of list prompts: options, a cursor and a scrolling window.
///
/// Moves with the arrows, `j`/`k`, Home/End and Page Up/Down. Typing a
/// number jumps to that option (several digits work, like `12`).
///
/// {@category cli}
abstract class ListPrompt<T, R> extends PromptView<R> {
  /// The options to choose from.
  final List<T> options;

  /// The text shown for each option.
  final List<String> labels;

  /// Dim text shown after each option, or empty strings for none.
  final List<String> notes;

  /// The highlighted row and visible window.
  late final ListCursor cursor;

  String _digits = '';

  /// Creates a list prompt over [options].
  ///
  /// * [format]: how each option is shown. Defaults to `toString()`.
  /// * [note]: dim extra text after an option, like a description.
  /// * [start]: the option highlighted at the start.
  /// * [pageSize]: how many rows show at once. Fits the screen when left out.
  ListPrompt(
    super.question,
    this.options, {
    String Function(T option)? format,
    String Function(T option)? note,
    int start = 0,
    int? pageSize,
  }) : labels = [
         for (final option in options) format?.call(option) ?? '$option',
       ],
       notes = [for (final option in options) note?.call(option) ?? ''] {
    if (options.isEmpty) throw ArgumentError.value(options, 'options', 'Empty');
    cursor = ListCursor(
      options.length,
      index: start,
      pageSize: pageSize ?? pageSizeFor(options.length),
    );
  }

  /// One row of the list, without the pointer. Override to add checkboxes.
  String row(int index) {
    final note = notes[index];

    return note.isEmpty ? labels[index] : '${labels[index]}  ${muted(note)}';
  }

  @override
  List<String> body() {
    final columns = Terminal.current.columns - 1;
    final above = moreLine(cursor.top, above: true);
    final below = moreLine(options.length - cursor.bottom, above: false);

    return [
      ?above,
      for (var i = cursor.top; i < cursor.bottom; i++)
        (i == cursor.index ? pointed(row(i)) : unpointed(row(i))).fitWidth(
          columns,
        ),
      ?below,
    ];
  }

  /// Moves the cursor for navigation keys and typed numbers. Gives back
  /// true if [press] was used.
  bool navigate(KeyPress press) {
    if (press.key == Key.char && RegExp(r'^\d$').hasMatch(press.char)) {
      _digits += press.char;
      var number = int.parse(_digits);
      if (number < 1 || number > options.length) {
        _digits = press.char;
        number = int.parse(_digits);
      }
      if (number >= 1 && number <= options.length) cursor.index = number - 1;

      return true;
    }
    _digits = '';
    if (press.isChar('k') || press.isChar('w')) {
      cursor.move(-1);

      return true;
    }
    if (press.isChar('j') || press.isChar('s')) {
      cursor.move(1);

      return true;
    }

    return cursor.handle(press);
  }

  /// Prints the options as a numbered list, for line mode.
  void printNumbered() {
    for (var i = 0; i < labels.length; i++) {
      PromptRunner.say('  ${'${i + 1})'.foreground(theme.hint)} ${row(i)}');
    }
  }
}
