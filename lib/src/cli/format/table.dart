import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

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
