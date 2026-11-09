/// The symbols prompts and widgets draw with, beyond the theme's basics.
///
/// Pick [PromptGlyphs.unicode] (the default) or [PromptGlyphs.ascii] for
/// terminals without good Unicode fonts, or make your own:
///
/// ```dart
/// AnsiTheme.current = AnsiTheme.current.copyWith(
///   glyphs: PromptGlyphs.unicode.copyWith(checked: '■', unchecked: '□'),
/// );
/// ```
///
/// {@category ansi}
class PromptGlyphs {
  /// A ticked checkbox in a multi-select.
  final String checked;

  /// An empty checkbox in a multi-select.
  final String unchecked;

  /// A filled star in a rating.
  final String star;

  /// An empty star in a rating.
  final String starEmpty;

  /// The filled part of a slider track.
  final String trackFill;

  /// The empty part of a slider track.
  final String trackEmpty;

  /// The handle on a slider.
  final String knob;

  /// Shown when there are more rows above.
  final String moreAbove;

  /// Shown when there are more rows below.
  final String moreBelow;

  /// A switch that is on, in a toggle list.
  final String toggleOn;

  /// A switch that is off, in a toggle list.
  final String toggleOff;

  /// A folder in a file picker.
  final String folder;

  /// A file in a file picker.
  final String file;

  /// The symbol in front of the question while a prompt is open.
  final String question;

  /// The mask for typed password characters.
  final String mask;

  /// Creates a glyph set. Anything left out keeps its Unicode default.
  const PromptGlyphs({
    this.checked = '◉',
    this.unchecked = '◯',
    this.star = '★',
    this.starEmpty = '☆',
    this.trackFill = '━',
    this.trackEmpty = '─',
    this.knob = '●',
    this.moreAbove = '↑',
    this.moreBelow = '↓',
    this.toggleOn = '◉ on ',
    this.toggleOff = '◯ off',
    this.folder = '▸',
    this.file = ' ',
    this.question = '?',
    this.mask = '•',
  });

  /// Unicode symbols, for modern terminals. The default.
  static const PromptGlyphs unicode = PromptGlyphs();

  /// Plain keyboard characters, for any terminal.
  static const PromptGlyphs ascii = PromptGlyphs(
    checked: '[x]',
    unchecked: '[ ]',
    star: '*',
    starEmpty: '.',
    trackFill: '=',
    trackEmpty: '-',
    knob: 'O',
    moreAbove: '^',
    moreBelow: 'v',
    toggleOn: '[on] ',
    toggleOff: '[off]',
    folder: '>',
    mask: '*',
  );

  /// A copy with some symbols swapped.
  PromptGlyphs copyWith({
    String? checked,
    String? unchecked,
    String? star,
    String? starEmpty,
    String? trackFill,
    String? trackEmpty,
    String? knob,
    String? moreAbove,
    String? moreBelow,
    String? toggleOn,
    String? toggleOff,
    String? folder,
    String? file,
    String? question,
    String? mask,
  }) => PromptGlyphs(
    checked: checked ?? this.checked,
    unchecked: unchecked ?? this.unchecked,
    star: star ?? this.star,
    starEmpty: starEmpty ?? this.starEmpty,
    trackFill: trackFill ?? this.trackFill,
    trackEmpty: trackEmpty ?? this.trackEmpty,
    knob: knob ?? this.knob,
    moreAbove: moreAbove ?? this.moreAbove,
    moreBelow: moreBelow ?? this.moreBelow,
    toggleOn: toggleOn ?? this.toggleOn,
    toggleOff: toggleOff ?? this.toggleOff,
    folder: folder ?? this.folder,
    file: file ?? this.file,
    question: question ?? this.question,
    mask: mask ?? this.mask,
  );
}
