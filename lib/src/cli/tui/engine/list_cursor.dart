// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:math' as math;

import 'key_press.dart';

/// The highlighted row of a list, plus the slice of rows that fits on screen.
///
/// Moving past either end wraps round when [wrap] is on. The visible window
/// scrolls so the highlighted row is always in it.
///
/// {@category cli}
class ListCursor {
  /// How many rows the list has.
  int _count;

  /// How many rows fit on screen at once.
  int pageSize;

  /// Whether moving past the last row goes back to the first, and back.
  final bool wrap;

  int _index;
  int _top = 0;

  /// Creates a cursor over [count] rows, starting on [index].
  ListCursor(int count, {this.pageSize = 10, int index = 0, this.wrap = true})
    : _count = count,
      _index = count == 0 ? 0 : index.clamp(0, count - 1) {
    _scroll();
  }

  /// The highlighted row, counting from 0.
  int get index => _index;

  set index(int value) {
    _index = _count == 0 ? 0 : value.clamp(0, _count - 1);
    _scroll();
  }

  /// How many rows the list has.
  int get count => _count;

  /// Changes how many rows there are, like after filtering. Goes back to the
  /// top row when [reset] is true.
  void resize(int count, {bool reset = false}) {
    _count = count;
    index = reset ? 0 : _index;
  }

  /// The first row on screen.
  int get top => _top;

  /// The rows on screen: from [top] up to, but not including, this.
  int get bottom => math.min(_top + pageSize, _count);

  /// Whether there are rows hidden above the window.
  bool get moreAbove => _top > 0;

  /// Whether there are rows hidden below the window.
  bool get moreBelow => bottom < _count;

  /// Moves by [step] rows (negative goes up).
  void move(int step) {
    if (_count == 0) return;
    final target = _index + step;
    _index = wrap ? target % _count : target.clamp(0, _count - 1);
    _scroll();
  }

  /// Moves for up, down, Home, End, Page Up and Page Down, plus Ctrl+P and
  /// Ctrl+N for up and down (handy in search boxes). Gives back true
  /// if [press] was one of those.
  bool handle(KeyPress press) {
    switch (press.key) {
      case Key.up:
        move(-1);
      case Key.ctrl when press.char == 'p':
        move(-1);
      case Key.down:
        move(1);
      case Key.ctrl when press.char == 'n':
        move(1);
      case Key.home:
        index = 0;
      case Key.end:
        index = _count - 1;
      case Key.pageUp:
        index = _index - pageSize;
      case Key.pageDown:
        index = _index + pageSize;
      default:
        return false;
    }

    return true;
  }

  /// Scrolls the window so [index] is in it.
  void _scroll() {
    if (pageSize < 1) pageSize = 1;
    if (_index < _top) _top = _index;
    if (_index >= _top + pageSize) _top = _index - pageSize + 1;
    final maxTop = math.max(_count - pageSize, 0);
    if (_top > maxTop) _top = maxTop;
  }
}
