import '../../../cmdline.dart';

/// Inclusive `[start, end]` pairs of code points that take two columns.
///
/// East Asian wide and fullwidth characters, plus emoji that show as
/// pictures by default.
const List<int> _wideRanges = <int>[
  0x1100, 0x115F, 0x231A, 0x231B, 0x2329, 0x232A, 0x23E9, 0x23EC, //
  0x23F0, 0x23F0, 0x23F3, 0x23F3, 0x25FD, 0x25FE, 0x2614, 0x2615,
  0x2648, 0x2653, 0x267F, 0x267F, 0x2693, 0x2693, 0x26A1, 0x26A1,
  0x26AA, 0x26AB, 0x26BD, 0x26BE, 0x26C4, 0x26C5, 0x26CE, 0x26CE,
  0x26D4, 0x26D4, 0x26EA, 0x26EA, 0x26F2, 0x26F3, 0x26F5, 0x26F5,
  0x26FA, 0x26FA, 0x26FD, 0x26FD, 0x2705, 0x2705, 0x270A, 0x270B,
  0x2728, 0x2728, 0x274C, 0x274C, 0x274E, 0x274E, 0x2753, 0x2755,
  0x2757, 0x2757, 0x2795, 0x2797, 0x27B0, 0x27B0, 0x27BF, 0x27BF,
  0x2B1B, 0x2B1C, 0x2B50, 0x2B50, 0x2B55, 0x2B55, 0x2E80, 0x303E,
  0x3041, 0x33FF, 0x3400, 0x4DBF, 0x4E00, 0x9FFF, 0xA000, 0xA4CF,
  0xA960, 0xA97F, 0xAC00, 0xD7A3, 0xF900, 0xFAFF, 0xFE10, 0xFE19,
  0xFE30, 0xFE6F, 0xFF00, 0xFF60, 0xFFE0, 0xFFE6, 0x16FE0, 0x16FE4,
  0x17000, 0x18CFF, 0x1AFF0, 0x1B2FF, 0x1F004, 0x1F004, 0x1F0CF, 0x1F0CF,
  0x1F18E, 0x1F18E, 0x1F191, 0x1F19A, 0x1F1E6, 0x1F1FF, 0x1F200, 0x1F251,
  0x1F260, 0x1F265, 0x1F300, 0x1F320, 0x1F32D, 0x1F335, 0x1F337, 0x1F37C,
  0x1F37E, 0x1F393, 0x1F3A0, 0x1F3CA, 0x1F3CF, 0x1F3D3, 0x1F3E0, 0x1F3F0,
  0x1F3F4, 0x1F3F4, 0x1F3F8, 0x1F43E, 0x1F440, 0x1F440, 0x1F442, 0x1F4FC,
  0x1F4FF, 0x1F53D, 0x1F54B, 0x1F54E, 0x1F550, 0x1F567, 0x1F57A, 0x1F57A,
  0x1F595, 0x1F596, 0x1F5A4, 0x1F5A4, 0x1F5FB, 0x1F64F, 0x1F680, 0x1F6C5,
  0x1F6CC, 0x1F6CC, 0x1F6D0, 0x1F6D2, 0x1F6D5, 0x1F6D7, 0x1F6DC, 0x1F6DF,
  0x1F6EB, 0x1F6EC, 0x1F6F4, 0x1F6FC, 0x1F7E0, 0x1F7EB, 0x1F7F0, 0x1F7F0,
  0x1F90C, 0x1F93A, 0x1F93C, 0x1F945, 0x1F947, 0x1F9FF, 0x1FA70, 0x1FAFF,
  0x20000, 0x2FFFD, 0x30000, 0x3FFFD,
];

/// Variation selector 16, which asks for the emoji (two column) look.
const int _emojiPresentation = 0xFE0F;

/// Matches one escape code at the start of a string, style or control.
final RegExp _leadingCode = RegExp(
  '^(?:$STYLE_CODE_REGEX|$CONTROL_CODE_REGEX|\x1B\\][^\x07\x1B]*(?:\x07|\x1B\\\\))',
);

/// Whether [rune] is in [_wideRanges].
bool _isWide(int rune) {
  var low = 0;
  var high = _wideRanges.length ~/ 2 - 1;
  while (low <= high) {
    final middle = (low + high) ~/ 2;
    if (rune < _wideRanges[middle * 2]) {
      high = middle - 1;
    } else if (rune > _wideRanges[middle * 2 + 1]) {
      low = middle + 1;
    } else {
      return true;
    }
  }

  return false;
}

/// How many columns one grapheme takes: 0, 1 or 2.
int graphemeWidth(String grapheme) {
  if (grapheme.isEmpty) return 0;
  final first = grapheme.runes.first;
  if (_isWide(first) || grapheme.runes.contains(_emojiPresentation)) return 2;

  return isNonPrintable(first) ? 0 : 1;
}

/// One piece of a styled string: an escape code or a grapheme.
typedef _Piece = ({String text, bool code});

/// Splits [text] into escape codes and graphemes, in order.
Iterable<_Piece> _pieces(String text) sync* {
  var rest = text;
  while (rest.isNotEmpty) {
    final escape = rest.indexOf(ESC);
    final plainPart = escape < 0 ? rest : rest.substring(0, escape);
    for (final grapheme in graphemes(plainPart)) {
      yield (text: grapheme, code: false);
    }
    if (escape < 0) return;
    rest = rest.substring(escape);
    final match = _leadingCode.firstMatch(rest);
    final length = match == null ? 1 : match.end;
    yield (text: rest.substring(0, length), code: true);
    rest = rest.substring(length);
  }
}

/// Measuring and fitting text by the columns it takes on screen.
///
/// Escape codes take no space, wide characters (CJK, most emoji) take two
/// columns and combining marks take none, so these line text up the way the
/// terminal draws it.
///
/// {@category ansi}
extension DisplayWidth on String {
  /// How many terminal columns this text takes, ignoring escape codes.
  ///
  /// ```dart
  /// 'abc'.width;        // 3
  /// '日本'.width;        // 4
  /// 'ok'.green.width;   // 2
  /// ```
  int get width {
    var columns = 0;
    for (final piece in _pieces(this)) {
      if (!piece.code) columns += graphemeWidth(piece.text);
    }

    return columns;
  }

  /// This text cut down to at most [columns] columns, keeping its styles.
  ///
  /// When it has to be cut, the last column becomes [ellipsis] (pass an
  /// empty string for a hard cut) and the styles are reset at the end.
  String fitWidth(int columns, {String ellipsis = ELLIPSIS}) {
    if (width <= columns) return this;
    final room = columns - ellipsis.width;
    final out = StringBuffer();
    var used = 0;
    var styled = false;
    for (final piece in _pieces(this)) {
      if (piece.code) {
        out.write(piece.text);
        styled = true;
        continue;
      }
      final size = graphemeWidth(piece.text);
      if (used + size > room) break;
      out.write(piece.text);
      used += size;
    }
    out.write(ellipsis);
    if (styled) out.write(RESET);

    return out.toString();
  }

  /// This text padded with spaces to [columns] columns.
  ///
  /// With [right], the spaces go in front. Text that is already wider is
  /// left alone.
  String padWidth(int columns, {bool right = false}) {
    final spaces = ' ' * (columns - width).clamp(0, columns);

    return right ? '$spaces$this' : '$this$spaces';
  }

  /// This text broken into lines of at most [columns] columns.
  ///
  /// Lines break at spaces where possible, and inside long words when they
  /// must. Existing line breaks are kept. Styles carry over to the next
  /// line, so coloured text stays coloured after a break.
  List<String> wrapWidth(int columns) {
    if (columns < 1) return [this];
    final lines = <String>[];
    for (final paragraph in split('\n')) {
      lines.addAll(_wrapParagraph(paragraph, columns));
    }

    return lines;
  }
}

/// Wraps one line of text with no line breaks in it.
List<String> _wrapParagraph(String text, int columns) {
  final lines = <String>[];
  final pieces = _pieces(text).toList();
  // The style codes in effect, so they can open the next line.
  final active = StringBuffer();
  var line = <_Piece>[];
  var used = 0;
  var lastSpace = -1;

  void flush(List<_Piece> pieces) {
    final textLine = pieces.map((piece) => piece.text).join();
    lines.add(active.isEmpty ? textLine : '$textLine$RESET');
  }

  for (final piece in pieces) {
    if (piece.code) {
      line.add(piece);
      if (piece.text == RESET || piece.text == '$CSI$SGR') {
        active.clear();
      } else if (styleCodeRegExp.hasMatch(piece.text)) {
        active.write(piece.text);
      }
      continue;
    }
    final size = graphemeWidth(piece.text);
    if (used + size > columns && used > 0) {
      final opening = active.toString();
      if (lastSpace >= 0 && piece.text != ' ') {
        // Move the word after the last space onto the next line.
        final carried = line.sublist(lastSpace + 1);
        flush(line.sublist(0, lastSpace));
        line = [if (opening.isNotEmpty) (text: opening, code: true), ...carried];
        used = carried.fold(
          0,
          (sum, piece) => sum + (piece.code ? 0 : graphemeWidth(piece.text)),
        );
      } else {
        flush(line);
        line = [if (opening.isNotEmpty) (text: opening, code: true)];
        used = 0;
      }
      lastSpace = -1;
      if (piece.text == ' ') continue;
    }
    if (piece.text == ' ') lastSpace = line.length;
    line.add(piece);
    used += size;
  }
  lines.add(line.map((piece) => piece.text).join());

  return lines;
}
