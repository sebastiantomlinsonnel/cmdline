import '../../../cmdline.dart';

/// Visual pickers for values: sliders, ranges, ratings, dates, files and
/// colours.
///
/// They behave like [Prompts]: live in a terminal, typed answers when input
/// is piped, defaults when unattended, and [PromptCancelled] on Esc or
/// Ctrl+C.
///
/// {@category cli}
abstract final class Pickers {
  /// Picks a whole number from [min] to [max] on a track.
  ///
  /// * [step]: how far one arrow press moves.
  /// * [start]: the value at the start (and when unattended).
  /// * [unit]: text after the number, like `%`.
  /// * [width]: how many columns wide the track is.
  ///
  /// ```dart
  /// final volume = Pickers.slider('Volume', start: 70, unit: '%');
  /// ```
  static int slider(
    String prompt, {
    int min = 0,
    int max = 100,
    int step = 1,
    int? start,
    String unit = '',
    int width = 30,
  }) => PromptRunner.run(
    SliderPrompt(
      prompt,
      min: min,
      max: max,
      step: step,
      start: start,
      unit: unit,
      width: width,
    ),
  );

  /// Picks a range from [min] to [max] with two handles. Tab swaps handles.
  ///
  /// ```dart
  /// final price = Pickers.range('Price', max: 500, initial: (start: 50, end: 200));
  /// print('${price.start} to ${price.end}');
  /// ```
  static IntRange range(
    String prompt, {
    int min = 0,
    int max = 100,
    int step = 1,
    IntRange? initial,
    String unit = '',
    int width = 30,
  }) => PromptRunner.run(
    RangePrompt(
      prompt,
      min: min,
      max: max,
      step: step,
      initial: initial,
      unit: unit,
      width: width,
    ),
  );

  /// Picks a score out of [max] stars. Number keys pick straight away.
  ///
  /// [labels] are words for each score, like `['Bad', 'Okay', 'Good']`.
  ///
  /// ```dart
  /// final stars = Pickers.rating('How was it?', labels: ['Awful', 'Bad', 'Okay', 'Good', 'Great']);
  /// ```
  static int rating(
    String prompt, {
    int max = 5,
    int? start,
    List<String> labels = const [],
  }) => PromptRunner.run(
    RatingPrompt(prompt, max: max, start: start, labels: labels),
  );

  /// Picks a day on a calendar. Gives back midnight on that day.
  ///
  /// * [start]: the day picked at the start. Today when left out.
  /// * [first] and [last]: the range of days allowed.
  ///
  /// ```dart
  /// final due = Pickers.date('Due date', first: DateTime.now());
  /// ```
  static DateTime date(
    String prompt, {
    DateTime? start,
    DateTime? first,
    DateTime? last,
  }) => PromptRunner.run(
    DatePrompt(prompt, start: start, first: first, last: last),
  );

  /// Browses folders to pick a file, and gives back its full path.
  ///
  /// * [folder]: where to start. The working folder when left out.
  /// * [extensions]: only show files ending in these, like `['.json']`.
  /// * [kind]: pick files, folders or either.
  /// * [showHidden]: show names starting with a dot.
  ///
  /// ```dart
  /// final config = Pickers.file('Config file', extensions: ['.yaml', '.json']);
  /// final output = Pickers.file('Output folder', kind: PathKind.folder);
  /// ```
  static String file(
    String prompt, {
    String? folder,
    List<String> extensions = const [],
    PathKind kind = PathKind.file,
    bool showHidden = false,
  }) => PromptRunner.run(
    FilePrompt(
      prompt,
      folder: folder,
      extensions: extensions,
      kind: kind,
      showHidden: showHidden,
    ),
  );

  /// Asks for a path, with Tab completing names. Gives back the full path.
  ///
  /// * [kind]: what the path must point to.
  /// * [mustExist]: refuse paths that don't exist yet.
  ///
  /// ```dart
  /// final target = Pickers.path('Copy to', kind: PathKind.folder);
  /// ```
  static String path(
    String prompt, {
    String? defaultValue,
    PathKind kind = PathKind.any,
    bool mustExist = true,
  }) => PromptRunner.run(
    PathPrompt(
      prompt,
      defaultValue: defaultValue,
      kind: kind,
      mustExist: mustExist,
    ),
  );

  /// Picks a colour from a grid of hues and shades, or as a typed hex code.
  ///
  /// ```dart
  /// final accent = Pickers.colour('Accent colour');
  /// AnsiTheme.current = AnsiTheme.current.copyWith(highlight: accent);
  /// ```
  static AnsiColourRgb colour(String prompt, {AnsiColourRgb? start}) =>
      PromptRunner.run(ColourPrompt(prompt, start: start));

  /// The same as [colour].
  static AnsiColourRgb color(String prompt, {AnsiColourRgb? start}) =>
      colour(prompt, start: start);
}
