import '../../../cmdline.dart';

/// Questions for the user: text, passwords, numbers, yes/no and lists.
///
/// In a terminal each prompt is live: it redraws as keys are pressed, shows
/// problems under the question, and ends as one `✔ question answer` line.
/// Without a terminal (piped input) the same calls ask one typed line at a
/// time, and in CI ([PromptMode.unattended]) they take their defaults. See
/// [PromptMode] for how that is picked.
///
/// Esc or Ctrl+C throws [PromptCancelled]. Everything is drawn with
/// [AnsiTheme.current].
///
/// {@category cli}
abstract final class Prompts {
  /// Asks a question and gives back what the user types.
  ///
  /// * [defaultValue]: used when the user just presses Enter. Shown dim in the
  ///   box; Tab puts it in the box to edit.
  /// * [hidden]: don't show what is typed (see also [password]).
  /// * [required]: an empty answer isn't allowed (unless there's a default).
  /// * [validator]: gives back a problem to show, or null if the answer is ok.
  /// * [placeholder]: dim text in the empty box, when there's no default.
  ///
  /// ```dart
  /// final name = Prompts.ask('Project name', defaultValue: 'my_app');
  /// final port = Prompts.ask('Port', validator: (a) =>
  ///     int.tryParse(a) == null ? 'Type a number' : null);
  /// ```
  static String ask(
    String prompt, {
    String? defaultValue,
    bool hidden = false,
    bool required = true,
    String? Function(String answer)? validator,
    String placeholder = '',
  }) => PromptRunner.run(
    TextPrompt<String>(
      prompt,
      defaultValue: defaultValue,
      placeholder: placeholder,
      mask: hidden ? AnsiTheme.current.glyphs.mask : null,
      parser: (text) => (
        value: text,
        problem: text.isEmpty && required
            ? 'An answer is needed'
            : validator?.call(text),
      ),
    ),
  );

  /// Asks for a password, showing a mask for each typed character.
  ///
  /// * [mask]: shown for each character. Defaults to the theme's
  ///   [PromptGlyphs.mask]; pass an empty string to show nothing.
  /// * [required] and [validator] work as in [ask].
  ///
  /// ```dart
  /// final secret = Prompts.password('Password', validator: (p) =>
  ///     p.length < 8 ? 'Use at least 8 characters' : null);
  /// ```
  static String password(
    String prompt, {
    String? mask,
    bool required = true,
    String? Function(String answer)? validator,
  }) => PromptRunner.run(
    TextPrompt<String>(
      prompt,
      mask: mask ?? AnsiTheme.current.glyphs.mask,
      parser: (text) => (
        value: text,
        problem: text.isEmpty && required
            ? 'An answer is needed'
            : validator?.call(text),
      ),
    ),
  );

  /// Asks for a whole number. Up and down change it by [step].
  ///
  /// [min] and [max] limit the answer; both are inclusive.
  ///
  /// ```dart
  /// final port = Prompts.integer('Port', defaultValue: 8080, min: 1, max: 65535);
  /// ```
  static int integer(
    String prompt, {
    int? defaultValue,
    int? min,
    int? max,
    int step = 1,
  }) => PromptRunner.run(
    TextPrompt<int>(
      prompt,
      defaultValue: defaultValue?.toString(),
      stepper: (text, direction) {
        final value =
            (int.tryParse(text) ?? defaultValue ?? min ?? 0) + step * direction;

        return '${_clamp(value, min, max)}';
      },
      parser: (text) {
        final value = int.tryParse(text.trim());
        if (value == null) return (value: null, problem: 'Type a whole number');

        return (value: value, problem: _rangeProblem(value, min, max));
      },
    ),
  );

  /// Asks for a number that can have decimals. Up and down change it by
  /// [step].
  ///
  /// [min] and [max] limit the answer; both are inclusive.
  ///
  /// ```dart
  /// final ratio = Prompts.decimal('Ratio', defaultValue: 0.5, min: 0, max: 1, step: 0.1);
  /// ```
  static double decimal(
    String prompt, {
    double? defaultValue,
    double? min,
    double? max,
    double step = 1,
  }) => PromptRunner.run(
    TextPrompt<double>(
      prompt,
      defaultValue: defaultValue?.toString(),
      stepper: (text, direction) {
        final value =
            (double.tryParse(text) ?? defaultValue ?? min ?? 0) +
            step * direction;
        final clamped = _clamp(value, min, max);
        // Round away float noise like 0.30000000000000004.
        final rounded = double.parse(clamped.toStringAsFixed(10));

        return '$rounded';
      },
      parser: (text) {
        final value = double.tryParse(text.trim());
        if (value == null) return (value: null, problem: 'Type a number');

        return (value: value, problem: _rangeProblem(value, min, max));
      },
    ),
  );

  /// Asks a yes or no question and gives back true for yes.
  ///
  /// The arrows or the y and n keys choose; Enter takes the highlighted
  /// answer. Without a [defaultValue] nothing is highlighted at the start.
  ///
  /// ```dart
  /// if (Prompts.confirm('Delete the build folder?', defaultValue: false)) {
  ///   CMD.fs.deleteFolder('build');
  /// }
  /// ```
  static bool confirm(String prompt, {bool? defaultValue}) =>
      PromptRunner.run(ConfirmPrompt(prompt, defaultValue: defaultValue));

  /// Asks for text over several lines. Ctrl+D finishes.
  ///
  /// ```dart
  /// final message = Prompts.multiline('Commit message', required: true);
  /// ```
  static String multiline(
    String prompt, {
    String defaultValue = '',
    bool required = false,
  }) => PromptRunner.run(
    MultilinePrompt(prompt, defaultValue: defaultValue, required: required),
  );

  /// Lets the user pick one of [options] and gives back the one they picked.
  ///
  /// The options are a list moved through with the arrow keys (or `j`/`k`),
  /// Home/End and Page Up/Down, and picked with Enter. Typing a number jumps
  /// to that option. Long lists scroll.
  ///
  /// * [format]: how each option is shown. Defaults to `toString()`.
  /// * [note]: dim text after each option, like a description.
  /// * [defaultOption]: the option highlighted at the start, and the answer
  ///   in [PromptMode.unattended].
  /// * [pageSize]: how many options show at once. Fits the screen when left
  ///   out.
  ///
  /// ```dart
  /// final colour = Prompts.select('Pick a colour', ['Red', 'Green', 'Blue']);
  /// final file = Prompts.select('Open which file?', files, format: basename);
  /// ```
  static T select<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    String Function(T option)? note,
    T? defaultOption,
    int? pageSize,
  }) {
    final start = defaultOption == null ? -1 : options.indexOf(defaultOption);

    return PromptRunner.run(
      SelectPrompt<T>(
        prompt,
        options,
        format: format,
        note: note,
        start: start < 0 ? 0 : start,
        pageSize: pageSize,
        hasDefault: start >= 0,
      ),
    );
  }

  /// The same as [select], kept for code written before it.
  static T menu<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    T? defaultOption,
  }) => select(prompt, options, format: format, defaultOption: defaultOption);

  /// Lets the user tick any number of [options], and gives back the ticked
  /// ones in list order.
  ///
  /// Space ticks the highlighted option, `a` ticks them all, and Enter
  /// finishes.
  ///
  /// * [selected]: the options ticked at the start.
  /// * [min] and [max]: how many must be ticked.
  /// * [format], [note] and [pageSize] work as in [select].
  ///
  /// ```dart
  /// final features = Prompts.multiSelect(
  ///   'Features',
  ///   ['Logging', 'Tests', 'Docs'],
  ///   selected: ['Tests'],
  ///   min: 1,
  /// );
  /// ```
  static List<T> multiSelect<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    String Function(T option)? note,
    Iterable<T> selected = const [],
    int min = 0,
    int? max,
    int? pageSize,
  }) => PromptRunner.run(
    MultiSelectPrompt<T>(
      prompt,
      options,
      format: format,
      note: note,
      pageSize: pageSize,
      ticked: {
        for (final option in selected)
          if (options.contains(option)) options.indexOf(option),
      },
      min: min,
      max: max,
    ),
  );

  /// Lets the user pick one of [options] by typing to filter them, like a
  /// command palette.
  ///
  /// Matching is fuzzy (see [Fuzzy]): `gco` finds `git checkout`. The best
  /// matches come first, with the matched letters underlined. [note] text is
  /// searched too, so it suits descriptions.
  ///
  /// ```dart
  /// final command = Prompts.search(
  ///   'Run',
  ///   commands,
  ///   format: (c) => c.name,
  ///   note: (c) => c.description,
  /// );
  /// ```
  static T search<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    String Function(T option)? note,
    T? defaultOption,
    int? pageSize,
  }) {
    final start = defaultOption == null ? -1 : options.indexOf(defaultOption);

    return PromptRunner.run(
      SearchPrompt<T>(
        prompt,
        options,
        format: format,
        note: note,
        defaultIndex: start < 0 ? null : start,
        pageSize: pageSize,
      ),
    );
  }

  /// Asks for a list of short words, like labels, shown as tags while typed.
  ///
  /// Enter or a comma adds a tag, Backspace removes the last one and Tab
  /// completes from [suggestions]. Enter on an empty box finishes.
  ///
  /// * [allowNew]: when false, only [suggestions] can be picked.
  /// * [initial]: the tags at the start.
  /// * [min]: the fewest tags needed.
  ///
  /// ```dart
  /// final labels = Prompts.tags('Labels', suggestions: ['bug', 'feature', 'docs']);
  /// ```
  static List<String> tags(
    String prompt, {
    List<String> suggestions = const [],
    bool allowNew = true,
    List<String> initial = const [],
    int min = 0,
  }) => PromptRunner.run(
    TagsPrompt(
      prompt,
      suggestions: suggestions,
      allowNew: allowNew,
      initial: initial,
      min: min,
    ),
  );

  /// Lets the user pick one of [options] laid out in a grid, moving in all
  /// four directions. Suits short options like sizes or regions.
  ///
  /// [columns] fits the screen when left out.
  ///
  /// ```dart
  /// final size = Prompts.grid('Size', ['XS', 'S', 'M', 'L', 'XL', 'XXL'], columns: 3);
  /// ```
  static T grid<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    T? defaultOption,
    int? columns,
  }) {
    final start = defaultOption == null ? -1 : options.indexOf(defaultOption);

    return PromptRunner.run(
      GridPrompt<T>(
        prompt,
        options,
        format: format,
        columns: columns,
        start: start < 0 ? 0 : start,
        hasDefault: start >= 0,
      ),
    );
  }

  /// Shows a list of on/off switches and gives back each name with its
  /// state.
  ///
  /// [switches] maps each name to whether it starts on. Space flips the
  /// highlighted one, right turns it on and left off.
  ///
  /// ```dart
  /// final settings = Prompts.toggles('Settings', {
  ///   'Dark mode': true,
  ///   'Telemetry': false,
  /// });
  /// if (settings['Dark mode']!) enableDarkMode();
  /// ```
  static Map<String, bool> toggles(
    String prompt,
    Map<String, bool> switches, {
    String Function(String name)? note,
  }) {
    final names = switches.keys.toList();
    final on = PromptRunner.run(
      TogglePrompt(
        prompt,
        names,
        note: note,
        on: {
          for (var i = 0; i < names.length; i++)
            if (switches[names[i]] ?? false) i,
        },
      ),
    ).toSet();

    return {for (final name in names) name: on.contains(name)};
  }

  static T _clamp<T extends num>(T value, T? min, T? max) {
    if (min != null && value < min) return min;
    if (max != null && value > max) return max;

    return value;
  }

  static String? _rangeProblem(num value, num? min, num? max) {
    if (min != null && max != null && (value < min || value > max)) {
      return 'Type a number from $min to $max';
    }
    if (min != null && value < min) return 'Type $min or more';
    if (max != null && value > max) return 'Type $max or less';

    return null;
  }
}
