part of 'cmd.dart';

class _Draw {
  const _Draw._();

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

  /// [rows] drawn as a table with the theme's line characters.
  ///
  /// Each cell can be any value, styled or not; widths are measured without
  /// escape codes so the columns line up. The [header] row is bold and has a
  /// line under it. Columns listed in [rightAligned] (counting from 0) line up
  /// on the right, which suits numbers. Print it with [CliTheme.say].
  ///
  /// ```dart
  /// CliTheme.say(table(
  ///   [['cli.dart', 84], ['menu.dart', 230]],
  ///   header: ['File', 'Lines'],
  ///   rightAligned: {1},
  /// ));
  /// ```
  String table(
    List<List<Object?>> rows, {
    List<Object?>? header,
    Set<int> rightAligned = const {},
  }) {
    final theme = CliTheme.current;
    final chars = theme.box;
    final allRows = [?header, ...rows];
    if (allRows.isEmpty) return '';

    final columns = allRows.map((row) => row.length).fold(0, math.max);
    final widths = List.filled(columns, 0);
    for (final row in allRows) {
      for (var i = 0; i < row.length; i++) {
        widths[i] = math.max(widths[i], '${row[i] ?? ''}'.plain.length);
      }
    }

    String edge(String text) => text.foreground(theme.border);
    String line(String left, String middle, String right) => edge(
      '$left${widths.map((w) => chars.horizontal * (w + 2)).join(middle)}$right',
    );
    String cells(List<Object?> row, {bool bold = false}) {
      final parts = [
        for (var i = 0; i < columns; i++)
          padPlain(
            bold
                ? '${i < row.length ? row[i] ?? '' : ''}'.bold
                : '${i < row.length ? row[i] ?? '' : ''}',
            widths[i],
            right: rightAligned.contains(i),
          ),
      ];

      return '${edge(chars.vertical)} '
          '${parts.join('$RESET ${edge(chars.vertical)} ')}$RESET '
          '${edge(chars.vertical)}';
    }

    return [
      line(chars.topLeft, chars.teeDown, chars.topRight),
      if (header != null) ...[
        cells(header, bold: true),
        line(chars.teeLeft, chars.cross, chars.teeRight),
      ],
      for (final row in rows) cells(row),
      line(chars.bottomLeft, chars.teeUp, chars.bottomRight),
    ].join('\n');
  }
}
