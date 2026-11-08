part of 'ansi_constants.dart';


/// One set of line characters for drawing boxes and tables.
///
/// Pick a ready-made set like [BoxChars.rounded] and use its parts:
///
/// ```dart
/// const box = BoxChars.rounded;
/// print('${box.topLeft}${box.horizontal * 5}${box.topRight}');
/// print('${box.vertical} hi! ${box.vertical}');
/// print('${box.bottomLeft}${box.horizontal * 5}${box.bottomRight}');
/// ```
///
/// {@category ansi}
class BoxChars {
  /// The top left corner, like `┌`.
  final String topLeft;

  /// The top right corner, like `┐`.
  final String topRight;

  /// The bottom left corner, like `└`.
  final String bottomLeft;

  /// The bottom right corner, like `┘`.
  final String bottomRight;

  /// A flat line, like `─`.
  final String horizontal;

  /// An upright line, like `│`.
  final String vertical;

  /// A left edge with a line going right, like `├`.
  final String teeLeft;

  /// A right edge with a line going left, like `┤`.
  final String teeRight;

  /// A bottom edge with a line going up, like `┴`.
  final String teeUp;

  /// A top edge with a line going down, like `┬`.
  final String teeDown;

  /// Two lines crossing, like `┼`.
  final String cross;

  /// Creates a custom set of box characters.
  const BoxChars({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.horizontal,
    required this.vertical,
    required this.teeLeft,
    required this.teeRight,
    required this.teeUp,
    required this.teeDown,
    required this.cross,
  });

  /// Thin lines with square corners: `┌─┐`.
  static const BoxChars light = BoxChars(
    topLeft: '┌',
    topRight: '┐',
    bottomLeft: '└',
    bottomRight: '┘',
    horizontal: '─',
    vertical: '│',
    teeLeft: '├',
    teeRight: '┤',
    teeUp: '┴',
    teeDown: '┬',
    cross: '┼',
  );

  /// Thick lines: `┏━┓`.
  static const BoxChars heavy = BoxChars(
    topLeft: '┏',
    topRight: '┓',
    bottomLeft: '┗',
    bottomRight: '┛',
    horizontal: '━',
    vertical: '┃',
    teeLeft: '┣',
    teeRight: '┫',
    teeUp: '┻',
    teeDown: '┳',
    cross: '╋',
  );

  /// Double lines: `╔═╗`.
  static const BoxChars doubleLine = BoxChars(
    topLeft: '╔',
    topRight: '╗',
    bottomLeft: '╚',
    bottomRight: '╝',
    horizontal: '═',
    vertical: '║',
    teeLeft: '╠',
    teeRight: '╣',
    teeUp: '╩',
    teeDown: '╦',
    cross: '╬',
  );

  /// Thin lines with round corners: `╭─╮`.
  static const BoxChars rounded = BoxChars(
    topLeft: '╭',
    topRight: '╮',
    bottomLeft: '╰',
    bottomRight: '╯',
    horizontal: '─',
    vertical: '│',
    teeLeft: '├',
    teeRight: '┤',
    teeUp: '┴',
    teeDown: '┬',
    cross: '┼',
  );

  /// Plain keyboard characters: `+-+`.
  ///
  /// A fallback for old consoles that can't show line characters.
  static const BoxChars ansi = BoxChars(
    topLeft: '+',
    topRight: '+',
    bottomLeft: '+',
    bottomRight: '+',
    horizontal: '-',
    vertical: '|',
    teeLeft: '+',
    teeRight: '+',
    teeUp: '+',
    teeDown: '+',
    cross: '+',
  );
}