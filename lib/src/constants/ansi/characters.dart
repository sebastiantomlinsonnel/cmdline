part of 'ansi_constants.dart';

/// A solid block that fills a whole character cell: `█`.
///
/// {@category ansi}
const String FULL_BLOCK = '█';

/// A mostly filled block: `▓`.
///
/// {@category ansi}
const String DARK_SHADE = '▓';

/// A half filled block: `▒`.
///
/// {@category ansi}
const String MEDIUM_SHADE = '▒';

/// A lightly filled block: `░`.
///
/// Good for the empty part of a progress bar.
///
/// {@category ansi}
const String LIGHT_SHADE = '░';

/// Blocks from empty to full height, for little bar charts (sparklines).
///
/// Index 0 is a space and index 8 is a full block, so `kBAR_LEVELS[4]` is
/// half height.
///
/// {@category ansi}
const List<String> kBAR_LEVELS = <String>[
  ' ',
  '▁',
  '▂',
  '▃',
  '▄',
  '▅',
  '▆',
  '▇',
  '█',
];

/// Blocks from 1/8 to full width, for smooth progress bars.
///
/// Use whole [FULL_BLOCK]s for the done part, then one of these for the
/// last partly done cell.
///
/// {@category ansi}
const List<String> kBAR_EIGHTHS = <String>[
  '▏',
  '▎',
  '▍',
  '▌',
  '▋',
  '▊',
  '▉',
  '█',
];

/// A tick mark for success: `✔`.
///
/// {@category ansi}
const String TICK = '✔';

/// A cross mark for failure: `✖`.
///
/// {@category ansi}
const String CROSS = '✖';

/// A warning sign: `⚠`.
///
/// {@category ansi}
const String WARNING = '⚠';

/// An information sign: `ℹ`.
///
/// {@category ansi}
const String INFO = 'ℹ';

/// An arrow pointing right: `➜`.
///
/// {@category ansi}
const String ARROW = '➜';

/// A round bullet for lists: `•`.
///
/// {@category ansi}
const String BULLET = '•';

/// Three dots as one character: `…`.
///
/// {@category ansi}
const String ELLIPSIS = '…';
