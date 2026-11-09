import '../../../../cmdline.dart';

/// Where to put the blinking cursor in a frame: a line and a column.
///
/// Both count from 0. The column counts screen columns, not characters.
typedef CursorSpot = ({int line, int column});

/// A block of lines at the bottom of the output that can be redrawn in place.
///
/// Prompts, spinners and task lists draw into a region again and again; each
/// [draw] replaces what was drawn before. Lines too wide for the screen wrap,
/// and the region counts the extra rows, so the old frame is fully wiped
/// even after wrapping (or a resize).
///
/// Styles are dropped when [AnsiTheme.useColour] is off, but cursor moves
/// still happen, so prompts work without colour.
///
/// {@category cli}
class LiveRegion {
  final Terminal _terminal;

  /// The width of each line last drawn, to work out how many rows they took.
  List<int> _widths = const [];

  /// How many rows above the bottom of the region the cursor is.
  int _rowsBelowCursor = 0;

  /// Rows between the top of the region and the cursor.
  int _rowsAboveCursor = 0;

  bool _cursorHidden = false;

  /// Creates a region on [terminal] (the current one when left out).
  LiveRegion([Terminal? terminal]) : _terminal = terminal ?? Terminal.current;

  /// Whether anything is drawn right now.
  bool get isEmpty => _widths.isEmpty;

  /// Draws [lines], replacing the last frame.
  ///
  /// With [cursor], the blinking cursor is shown at that spot; without it the
  /// cursor is hidden.
  void draw(List<String> lines, {CursorSpot? cursor}) {
    final out = StringBuffer(SYNC_START)..write(_moveToTop());
    out.write('\r$CLEAR_TO_SCREEN_END');
    for (final line in lines) {
      out
        ..write(_paint(line))
        ..write(AnsiTheme.useColour ? '$RESET\n' : '\n');
    }
    _widths = [for (final line in lines) line.width];
    final total = _rowsFor(_widths.length);
    _rowsAboveCursor = total;
    _rowsBelowCursor = 0;

    if (cursor == null || lines.isEmpty) {
      if (!_cursorHidden) out.write(HIDE_CURSOR);
      _cursorHidden = true;
    } else {
      out.write(_placeCursor(cursor, total));
      if (_cursorHidden) out.write(SHOW_CURSOR);
      _cursorHidden = false;
    }
    out.write(SYNC_END);
    _terminal.write(out.toString());
  }

  /// Wipes the region off the screen and shows the cursor again.
  void clear() {
    if (_widths.isEmpty && !_cursorHidden) return;
    _terminal.write('${_moveToTop()}\r$CLEAR_TO_SCREEN_END$SHOW_CURSOR');
    _reset();
  }

  /// Replaces the region with [lines] for good, and shows the cursor.
  ///
  /// The lines stay on screen as normal output, and the region starts empty
  /// again below them.
  void finish(List<String> lines) {
    final out = StringBuffer('${_moveToTop()}\r$CLEAR_TO_SCREEN_END');
    for (final line in lines) {
      out.write('${_paint(line)}${AnsiTheme.useColour ? RESET : ''}\n');
    }
    out.write(SHOW_CURSOR);
    _terminal.write(out.toString());
    _reset();
  }

  /// Forgets the drawn lines without touching the screen.
  void _reset() {
    _widths = const [];
    _rowsAboveCursor = 0;
    _rowsBelowCursor = 0;
    _cursorHidden = false;
  }

  /// The escape code to move from the cursor to the top row of the region.
  String _moveToTop() => _rowsAboveCursor > 0 ? cursorUp(_rowsAboveCursor) : '';

  /// Moves from the bottom of the region to [spot], given [total] rows.
  String _placeCursor(CursorSpot spot, int total) {
    final columns = _columns;
    final line = spot.line.clamp(0, _widths.length - 1);
    final row = _rowsFor(line) + spot.column ~/ columns;
    final column = spot.column % columns;
    _rowsAboveCursor = row;
    _rowsBelowCursor = total - row;
    final up = _rowsBelowCursor > 0 ? cursorUp(_rowsBelowCursor) : '';

    return '$up\r${column > 0 ? cursorRight(column) : ''}';
  }

  /// How many screen rows the first [count] drawn lines take.
  int _rowsFor(int count) {
    final columns = _columns;
    var rows = 0;
    for (var i = 0; i < count && i < _widths.length; i++) {
      rows += _widths[i] <= columns ? 1 : (_widths[i] + columns - 1) ~/ columns;
    }

    return rows;
  }

  int get _columns => _terminal.columns < 1 ? 1 : _terminal.columns;

  /// [line] without styles when colour is off.
  static String _paint(String line) =>
      AnsiTheme.useColour ? line : line.replaceAll(styleCodeRegExp, '');
}
