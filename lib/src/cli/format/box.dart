import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

/// [text] drawn inside a box made of the theme's line characters.
///
/// The text can have several lines and its own styles; widths are measured
/// without escape codes so the right edge lines up. An optional [title] sits
/// in the top line. Print it with [CliTheme.say].
///
/// ```dart
/// CliTheme.say(box('Saved 3 files'.bold, title: 'Done'));
/// // ╭─ Done ────────╮
/// // │ Saved 3 files │
/// // ╰───────────────╯
/// ```
String box(String text, {String? title}) {
  final theme = CliTheme.current;
  final chars = theme.box;
  final lines = text.split('\n');
  final titleWidth = title == null ? 0 : title.plain.length + 3;
  final width = math.max(
    lines.map((line) => line.plain.length).fold(0, math.max),
    titleWidth,
  );

  String edge(String text) => text.foreground(theme.border);

  final top = title == null
      ? edge(
          '${chars.topLeft}${chars.horizontal * (width + 2)}${chars.topRight}',
        )
      : '${edge('${chars.topLeft}${chars.horizontal} ')}${title.bold}'
            '${edge(' ${chars.horizontal * (width - titleWidth + 2)}${chars.topRight}')}';
  final bottom = edge(
    '${chars.bottomLeft}${chars.horizontal * (width + 2)}${chars.bottomRight}',
  );

  return [
    top,
    for (final line in lines)
      '${edge(chars.vertical)} ${padPlain(line, width)}$RESET '
          '${edge(chars.vertical)}',
    bottom,
  ].join('\n');
}

/// [text] padded with spaces to [width] visible characters.
///
/// Escape codes don't count towards the width, so styled text pads
/// correctly. With [right], the spaces go in front.
String padPlain(String text, int width, {bool right = false}) {
  final spaces = ' ' * math.max(width - text.plain.length, 0);

  return right ? '$spaces$text' : '$text$spaces';
}
