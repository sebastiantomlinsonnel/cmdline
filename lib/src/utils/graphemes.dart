// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Forward grapheme cluster breaking, ported from package:characters 1.4.1
// (lib/src/grapheme_clusters/breaks.dart and constants.dart). It drives the
// generated tables in `table.dart`, which come from the same version.

import '../ansi/constants/table.dart' show high, low, move;

/// Grapheme break category of an unpaired surrogate.
const int _categoryControl = 1;

/// Synthetic end-of-text input category.
const int _categoryEoT = 18;

/// Flag value in the automaton output meaning "no break here".
const int _flagNoBreak = 0;

/// Mask of the low flag bits in an automaton state.
const int _maskFlags = 3;

/// Width of one row in the automaton tables.
const int _automatonRowLength = 20;

/// Start-of-text state that suppresses the break before the first grapheme.
const int _stateSoTNoBreak = 0x0C * _automatonRowLength;

/// Steps through the grapheme cluster breaks of [_base] from start to end.
class _Breaks {
  _Breaks(this._base) : _end = _base.length;

  final String _base;
  final int _end;
  int _cursor = 0;
  int _state = _stateSoTNoBreak;

  /// The index of the next break, or -1 once the end has been reached.
  int nextBreak() {
    while (_cursor < _end) {
      final breakAt = _cursor;
      _step();
      if (_state & _maskFlags != _flagNoBreak) {
        return breakAt;
      }
    }
    _state = move(_state, _categoryEoT);
    if (_state & _maskFlags != _flagNoBreak) return _cursor;
    return -1;
  }

  /// Feeds the next code point into the state machine.
  void _step() {
    final char = _base.codeUnitAt(_cursor++);
    final surrogate = char ^ 0xD800;
    if (surrogate > 0x3FF) {
      _state = move(_state, low(char));
      return;
    }
    int category;
    int nextSurrogate;
    if (_cursor < _end &&
        (nextSurrogate = _base.codeUnitAt(_cursor) ^ 0xDC00) <= 0x3FF) {
      category = high(surrogate, nextSurrogate);
      _cursor++;
    } else {
      category = _categoryControl;
    }
    _state = move(_state, category);
  }
}

/// Splits [string] into user-perceived characters (grapheme clusters).
///
/// Follows the Unicode grapheme breaking rules, so an emoji family, a flag or a
/// letter followed by combining accents each come back as one element.
/// An empty string yields nothing.
Iterable<String> graphemes(String string) sync* {
  if (string.isEmpty) return;
  final breaks = _Breaks(string);
  var start = 0;
  int brk;
  while ((brk = breaks.nextBreak()) >= 0) {
    yield string.substring(start, brk);
    start = brk;
  }
}
