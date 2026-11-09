import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

/// The kinds of message a [Widgets.callout] can show.
///
/// {@category cli}
enum Tone {
  /// Neutral information, in the theme's info colour.
  info,

  /// Something that worked, in the success colour.
  success,

  /// Something to watch out for, in the warn colour.
  warn,

  /// Something that went wrong, in the error colour.
  error,
}

/// One line of a [Widgets.tree]: a label and the lines under it.
///
/// {@category cli}
class TreeNode {
  /// The text shown for this line.
  final String label;

  /// The lines nested under this one.
  final List<TreeNode> children;

  /// Creates a tree line.
  const TreeNode(this.label, [this.children = const []]);
}

/// Text widgets for the terminal: boxes, tables, trees and lists.
///
/// Each one gives back a string (lines joined with `\n`) drawn with
/// [AnsiTheme.current]; print it with [AnsiTheme.say]. Widths are measured
/// the way the terminal draws text (see [DisplayWidth]), so styled text,
/// CJK and emoji line up.
///
/// {@category cli}
abstract final class Widgets {
  /// [text] drawn inside a box made of the theme's line characters.
  ///
  /// The text can have several lines and its own styles. An optional
  /// [title] sits in the top line, and [colour] changes the colour of the
  /// box lines (the theme's border colour by default).
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.box('Saved 3 files'.bold, title: 'Done'));
  /// // ╭─ Done ────────╮
  /// // │ Saved 3 files │
  /// // ╰───────────────╯
  /// ```
  static String box(String text, {String? title, AnsiInk? colour}) {
    final theme = AnsiTheme.current;
    final chars = theme.box;
    final lines = text.split('\n');
    final titleWidth = title == null ? 0 : title.width + 3;
    final width = math.max(
      lines.map((line) => line.width).fold(0, math.max),
      titleWidth,
    );

    String edge(String text) => text.foreground(colour ?? theme.border);

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
        '${edge(chars.vertical)} ${line.padWidth(width)}$RESET '
            '${edge(chars.vertical)}',
      bottom,
    ].join('\n');
  }

  /// A boxed message with an icon and a coloured border, for notes,
  /// warnings and errors that should stand out.
  ///
  /// [title] defaults to the [tone]'s name, like `Warning`. Long text wraps
  /// to fit the screen.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.callout(
  ///   'The config file is missing, so defaults are used.',
  ///   tone: Tone.warn,
  /// ));
  /// ```
  static String callout(String text, {Tone tone = Tone.info, String? title}) {
    final theme = AnsiTheme.current;
    final (colour, icon, name) = switch (tone) {
      Tone.info => (theme.info, INFO, 'Note'),
      Tone.success => (theme.success, theme.tick, 'Done'),
      Tone.warn => (theme.warn, WARNING, 'Warning'),
      Tone.error => (theme.error, theme.cross, 'Error'),
    };
    final room = math.max(Terminal.current.columns - 4, 10);

    return box(
      text.wrapWidth(room).join('\n'),
      title: '$icon ${title ?? name}'.foreground(colour),
      colour: colour,
    );
  }

  /// [text] padded with spaces to [width] columns.
  ///
  /// Escape codes don't count towards the width, so styled text pads
  /// correctly. With [right], the spaces go in front.
  static String padPlain(String text, int width, {bool right = false}) =>
      text.padWidth(width, right: right);

  /// [rows] drawn as a table with the theme's line characters.
  ///
  /// Each cell can be any value, styled or not. The [header] row is bold
  /// and has a line under it. Columns listed in [rightAligned] (counting
  /// from 0) line up on the right, which suits numbers.
  ///
  /// The table fits in [maxWidth] columns (the screen width when left out):
  /// the widest columns shrink first, and their cells wrap onto more lines,
  /// or are cut short with `…` when [wrap] is false. Cells can also hold
  /// several lines of their own.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.table(
  ///   [['cli.dart', 84], ['prompts.dart', 230]],
  ///   header: ['File', 'Lines'],
  ///   rightAligned: {1},
  /// ));
  /// ```
  static String table(
    List<List<Object?>> rows, {
    List<Object?>? header,
    Set<int> rightAligned = const {},
    int? maxWidth,
    bool wrap = true,
  }) {
    final theme = AnsiTheme.current;
    final chars = theme.box;
    final allRows = [?header, ...rows];
    if (allRows.isEmpty) return '';

    final columns = allRows.map((row) => row.length).fold(0, math.max);
    String cell(List<Object?> row, int i) => i < row.length ? '${row[i] ?? ''}' : '';

    final widths = List.filled(columns, 0);
    for (final row in allRows) {
      for (var i = 0; i < columns; i++) {
        for (final line in cell(row, i).split('\n')) {
          widths[i] = math.max(widths[i], line.width);
        }
      }
    }
    _shrink(widths, (maxWidth ?? Terminal.current.columns) - (columns * 3 + 1));

    String edge(String text) => text.foreground(theme.border);
    String line(String left, String middle, String right) => edge(
      '$left${widths.map((w) => chars.horizontal * (w + 2)).join(middle)}$right',
    );
    List<String> cells(List<Object?> row, {bool bold = false}) {
      final parts = [
        for (var i = 0; i < columns; i++)
          [
            for (final text in cell(row, i).split('\n'))
              ...(wrap ? text.wrapWidth(widths[i]) : [text.fitWidth(widths[i])]),
          ],
      ];
      final height = parts.map((p) => p.length).fold(1, math.max);

      return [
        for (var y = 0; y < height; y++)
          '${edge(chars.vertical)} '
              '${[
                for (var i = 0; i < columns; i++)
                  (y < parts[i].length ? (bold ? parts[i][y].bold : parts[i][y]) : '')
                      .padWidth(widths[i], right: rightAligned.contains(i)),
              ].join('$RESET ${edge(chars.vertical)} ')}$RESET '
              '${edge(chars.vertical)}',
      ];
    }

    return [
      line(chars.topLeft, chars.teeDown, chars.topRight),
      if (header != null) ...[
        ...cells(header, bold: true),
        line(chars.teeLeft, chars.cross, chars.teeRight),
      ],
      for (final row in rows) ...cells(row),
      line(chars.bottomLeft, chars.teeUp, chars.bottomRight),
    ].join('\n');
  }

  /// Narrows the widest of [widths] until they add up to [room] or less.
  static void _shrink(List<int> widths, int room) {
    const narrowest = 3;
    var total = widths.fold(0, (sum, w) => sum + w);
    while (total > room) {
      var widest = 0;
      for (var i = 1; i < widths.length; i++) {
        if (widths[i] > widths[widest]) widest = i;
      }
      if (widths[widest] <= narrowest) return;
      widths[widest]--;
      total--;
    }
  }

  /// [entries] as lined-up `key  value` pairs, like a settings summary.
  ///
  /// Keys show in the theme's hint colour. Values with several lines stay
  /// lined up under the first.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.keyValue({
  ///   'Name': 'my_app',
  ///   'Version': '1.2.0',
  ///   'Path': Directory.current.path,
  /// }));
  /// ```
  static String keyValue(Map<String, Object?> entries, {String separator = '  '}) {
    final theme = AnsiTheme.current;
    final width = entries.keys.map((key) => key.width).fold(0, math.max);
    final indent = ' ' * (width + separator.width);

    return [
      for (final MapEntry(:key, :value) in entries.entries)
        '${key.padWidth(width).foreground(theme.hint)}$separator'
            '${'${value ?? ''}'.split('\n').join('\n$indent')}',
    ].join('\n');
  }

  /// [roots] drawn as a tree with the theme's line characters.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.tree([
  ///   TreeNode('lib', [
  ///     TreeNode('src', [TreeNode('cli.dart')]),
  ///     TreeNode('cmdline.dart'),
  ///   ]),
  /// ]));
  /// // lib
  /// // ├─ src
  /// // │  ╰─ cli.dart
  /// // ╰─ cmdline.dart
  /// ```
  static String tree(List<TreeNode> roots) {
    final theme = AnsiTheme.current;
    final chars = theme.box;
    final lines = <String>[];

    void walk(List<TreeNode> nodes, String prefix) {
      for (var i = 0; i < nodes.length; i++) {
        final last = i == nodes.length - 1;
        final branch = '${last ? chars.bottomLeft : chars.teeLeft}${chars.horizontal} ';
        final carry = last ? '   ' : '${chars.vertical}  ';
        final labelLines = nodes[i].label.split('\n');
        lines.add('${(prefix + branch).foreground(theme.border)}${labelLines.first}');
        for (final more in labelLines.skip(1)) {
          lines.add('${(prefix + carry).foreground(theme.border)}$more');
        }
        walk(nodes[i].children, prefix + carry);
      }
    }

    for (final root in roots) {
      lines.add(root.label);
      walk(root.children, '');
    }

    return lines.join('\n');
  }

  /// [items] as a bulleted list, or a numbered one with [numbered].
  ///
  /// Long items wrap to fit the screen, lined up after the bullet.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.bullets(['Install Dart', 'Run dart pub get']));
  /// ```
  static String bullets(List<Object?> items, {bool numbered = false}) {
    final theme = AnsiTheme.current;
    final marks = [
      for (var i = 0; i < items.length; i++) numbered ? '${i + 1}.' : BULLET,
    ];
    final width = marks.map((mark) => mark.width).fold(0, math.max);
    final room = math.max(Terminal.current.columns - width - 3, 10);

    return [
      for (var i = 0; i < items.length; i++)
        for (final (n, line) in '${items[i] ?? ''}'.wrapWidth(room).indexed)
          n == 0
              ? '${marks[i].padWidth(width, right: numbered).foreground(theme.hint)} $line'
              : '${' ' * width} $line',
    ].join('\n');
  }

  /// A line across the screen, with an optional [title] in it.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.rule(title: 'Results'));
  /// // ── Results ─────────────────────────
  /// ```
  static String rule({String? title, int? width}) {
    final theme = AnsiTheme.current;
    final total = width ?? Terminal.current.columns - 1;
    final line = theme.box.horizontal;
    if (title == null) return (line * total).foreground(theme.border);
    final rest = math.max(total - title.width - 4, 0);

    return '${'$line$line '.foreground(theme.border)}${title.bold}'
        '${' ${line * rest}'.foreground(theme.border)}';
  }

  /// A lined-up list of keys and what they do, for help screens.
  ///
  /// ```dart
  /// AnsiTheme.say(Widgets.hotkeys([
  ///   ('↑↓', 'move'),
  ///   ('enter', 'open'),
  ///   ('q', 'quit'),
  /// ]));
  /// ```
  static String hotkeys(List<KeyHint> keys) {
    final theme = AnsiTheme.current;
    final width = keys.map((hint) => hint.$1.width).fold(0, math.max);

    return [
      for (final (key, action) in keys)
        '  ${key.padWidth(width).bold.foreground(theme.key)}  $action',
    ].join('\n');
  }
}
