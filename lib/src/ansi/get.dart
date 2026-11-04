//
// /// The 16 standard xterm colours as `0xAARRGGBB` values, used for codes
// /// 30–37 / 90–97 (and 256-colour indexes 0–15).
// ///
// /// Indexes 0–7 are the normal colours (black, red, green, yellow, blue,
// /// magenta, cyan, white) and 8–15 are their bright versions.
// const List<int> ansiPalette = [
//   0xFF000000, // black
//   0xFFCD3131, // red
//   0xFF0DBC79, // green
//   0xFFE5E510, // yellow
//   0xFF2472C8, // blue
//   0xFFBC3FBC, // magenta
//   0xFF11A8CD, // cyan
//   0xFFE5E5E5, // white
//   0xFF666666, // bright black
//   0xFFF14C4C, // bright red
//   0xFF23D18B, // bright green
//   0xFFF5F543, // bright yellow
//   0xFF3B8EEA, // bright blue
//   0xFFD670D6, // bright magenta
//   0xFF29B8DB, // bright cyan
//   0xFFFFFFFF, // bright white
// ];
//
// int _argb(int r, int g, int b) => 0xFF000000 | (r << 16) | (g << 8) | b;
//
// /// Colour for a 256-colour palette index.
// int _ansi256(int n) {
//   if (n < 16) return ansiPalette[n];
//   if (n >= 232) {
//     final v = 8 + (n - 232) * 10;
//     return _argb(v, v, v);
//   }
//   final i = n - 16;
//   int level(int c) => c == 0 ? 0 : 55 + c * 40;
//   return _argb(level(i ~/ 36), level((i ~/ 6) % 6), level(i % 6));
// }
//
// final RegExp _ansiSgr = RegExp(r'\x1B\[([0-9;]*)m');
// // Any other escape sequence (cursor movement, clear line, ...).
// final RegExp _ansiOther = RegExp(r'\x1B\[[0-9;?]*[A-Za-ln-z]|\x1B[^\[]');
//
// /// The text style set by ANSI SGR codes at some point in a string.
// ///
// /// Colours are `0xAARRGGBB` ints. A `null` colour means "use the default".
// class AnsiStyle {
//   /// Text colour, or `null` for the default.
//   final int? foreground;
//
//   /// Background colour, or `null` for none.
//   final int? background;
//
//   /// Bold text (code `1`).
//   final bool bold;
//
//   /// Dim text (code `2`).
//   final bool dim;
//
//   /// Italic text (code `3`).
//   final bool italic;
//
//   /// Underlined text (code `4`).
//   final bool underline;
//
//   /// Struck-through text (code `9`).
//   final bool strikethrough;
//
//   const AnsiStyle({
//     this.foreground,
//     this.background,
//     this.bold = false,
//     this.dim = false,
//     this.italic = false,
//     this.underline = false,
//     this.strikethrough = false,
//   });
//
//   /// `true` when no codes are active.
//   bool get isPlain =>
//       foreground == null &&
//           background == null &&
//           !bold &&
//           !dim &&
//           !italic &&
//           !underline &&
//           !strikethrough;
//
//   @override
//   bool operator ==(Object other) =>
//       other is AnsiStyle &&
//           other.foreground == foreground &&
//           other.background == background &&
//           other.bold == bold &&
//           other.dim == dim &&
//           other.italic == italic &&
//           other.underline == underline &&
//           other.strikethrough == strikethrough;
//
//   @override
//   int get hashCode => Object.hash(
//     foreground,
//     background,
//     bold,
//     dim,
//     italic,
//     underline,
//     strikethrough,
//   );
//
//   @override
//   String toString() =>
//       'AnsiStyle(fg: $foreground, bg: $background, bold: $bold, dim: $dim, '
//           'italic: $italic, underline: $underline, strikethrough: $strikethrough)';
// }
//
// /// A run of text with one [AnsiStyle].
// class AnsiSegment {
//   /// The text, with escape codes removed.
//   final String text;
//
//   /// The style for [text], or `null` when no codes are active.
//   final AnsiStyle? style;
//
//   const AnsiSegment(this.text, [this.style]);
//
//   @override
//   bool operator ==(Object other) =>
//       other is AnsiSegment && other.text == text && other.style == style;
//
//   @override
//   int get hashCode => Object.hash(text, style);
//
//   @override
//   String toString() => 'AnsiSegment(${text.toEscaped()}, $style)';
// }
//
// class _AnsiState {
//   int? fg;
//   int? bg;
//   bool bold = false;
//   bool dim = false;
//   bool italic = false;
//   bool underline = false;
//   bool strike = false;
//
//   void reset() {
//     fg = bg = null;
//     bold = dim = italic = underline = strike = false;
//   }
//
//   AnsiStyle? toStyle() {
//     final style = AnsiStyle(
//       foreground: fg,
//       background: bg,
//       bold: bold,
//       dim: dim,
//       italic: italic,
//       underline: underline,
//       strikethrough: strike,
//     );
//     return style.isPlain ? null : style;
//   }
//
//   /// Applies one SGR parameter list, e.g. "1;31" or "38;5;208".
//   void apply(String params) {
//     final codes = params.isEmpty
//         ? [0]
//         : params.split(';').map((s) => int.tryParse(s) ?? 0).toList();
//     for (var i = 0; i < codes.length; i++) {
//       final c = codes[i];
//       if (c == 38 || c == 48) {
//         int? color;
//         if (i + 2 < codes.length && codes[i + 1] == 5) {
//           color = _ansi256(codes[i + 2].clamp(0, 255));
//           i += 2;
//         } else if (i + 4 < codes.length && codes[i + 1] == 2) {
//           color = _argb(
//             codes[i + 2].clamp(0, 255),
//             codes[i + 3].clamp(0, 255),
//             codes[i + 4].clamp(0, 255),
//           );
//           i += 4;
//         }
//         if (c == 38) {
//           fg = color;
//         } else {
//           bg = color;
//         }
//         continue;
//       }
//       switch (c) {
//         case 0:
//           reset();
//         case 1:
//           bold = true;
//         case 2:
//           dim = true;
//         case 3:
//           italic = true;
//         case 4:
//           underline = true;
//         case 9:
//           strike = true;
//         case 22:
//           bold = dim = false;
//         case 23:
//           italic = false;
//         case 24:
//           underline = false;
//         case 29:
//           strike = false;
//         case 39:
//           fg = null;
//         case 49:
//           bg = null;
//         case >= 30 && <= 37:
//           fg = ansiPalette[c - 30];
//         case >= 90 && <= 97:
//           fg = ansiPalette[c - 90 + 8];
//         case >= 40 && <= 47:
//           bg = ansiPalette[c - 40];
//         case >= 100 && <= 107:
//           bg = ansiPalette[c - 100 + 8];
//       }
//     }
//   }
// }
//
// /// Splits a string containing ANSI escape codes into styled [AnsiSegment]s.
// ///
// /// In Flutter, `parseAnsi` from the `recollect` package turns the result into
// /// `TextSpan`s.
// ///
// /// Text with no active codes gets a `null` style. Escape sequences that don't
// /// style text (cursor moves, clearing lines) are removed.
// ///
// /// Supported SGR codes (`ESC[<codes>m`, combined with `;`):
// ///
// /// | Code                 | Effect                                  |
// /// |----------------------|-----------------------------------------|
// /// | `0` or empty         | Reset everything                        |
// /// | `1` / `2`            | Bold / dim                              |
// /// | `3`                  | Italic                                  |
// /// | `4`                  | Underline                               |
// /// | `9`                  | Strikethrough                           |
// /// | `22`                 | Not bold, not dim                       |
// /// | `23` / `24` / `29`   | Not italic / not underlined / not struck|
// /// | `30`–`37`, `90`–`97` | Text colour (normal / bright)           |
// /// | `40`–`47`, `100`–`107` | Background colour (normal / bright)   |
// /// | `39` / `49`          | Default text / background colour        |
// /// | `38;5;n` / `48;5;n`  | 256-colour text / background            |
// /// | `38;2;r;g;b` / `48;2;r;g;b` | RGB text / background            |
// ///
// /// Styles carry over until reset, as in a terminal:
// ///
// /// ```dart
// /// final segments = parseAnsiSegments('\x1B[1mBold \x1B[31mand red\x1B[0m normal');
// /// // [AnsiSegment('Bold ', bold), AnsiSegment('and red', bold + red),
// /// //  AnsiSegment(' normal', null)]
// /// ```
// List<AnsiSegment> parseAnsiSegments(String input) {
//   final segments = <AnsiSegment>[];
//   final state = _AnsiState();
//   var last = 0;
//
//   void emit(String text) {
//     text = text.replaceAll(_ansiOther, '');
//     if (text.isNotEmpty) {
//       segments.add(AnsiSegment(text, state.toStyle()));
//     }
//   }
//
//   for (final m in _ansiSgr.allMatches(input)) {
//     emit(input.substring(last, m.start));
//     state.apply(m.group(1)!);
//     last = m.end;
//   }
//   emit(input.substring(last));
//   return segments;
// }
//
// /// Removes every ANSI escape sequence from [input], leaving plain text.
// ///
// /// ```dart
// /// stripAnsi('\x1B[31mError\x1B[0m: file not found'); // 'Error: file not found'
// /// ```
// String stripAnsi(String input) =>
//     input.replaceAll(_ansiSgr, '').replaceAll(_ansiOther, '');
