part of 'ansi_constants.dart';

/// Matches an ANSI style code, like `\x1B[31m` or `\x1B[1;38;5;196m`.
///
/// These are SGR codes ("Select Graphic Rendition"), which set colour,
/// bold, underline and so on. They always end in `m`. Group 1 holds the
/// numbers between `[` and `m`, such as `1;38;5;196`, or is empty for
/// `\x1B[m`, which means reset.
RegExp get styleCodeRegExp => RegExp(STYLE_CODE_REGEX);

/// The string used for [styleCodeRegExp]
const String STYLE_CODE_REGEX = r'\x1B\[([0-9;]*)m';

/// Matches any ANSI escape code that isn't a style code.
///
/// Covers terminal commands such as moving the cursor (`\x1B[5;10H`),
/// clearing the line (`\x1B[2K`) and hiding the cursor (`\x1B[?25l`): any
/// `\x1B[` sequence ending in a letter other than `m`. Also covers short
/// two-character codes like `\x1B7` (save cursor position). These change
/// the terminal rather than the text, so they are removed and never styled.
RegExp get controlCodeRegExp => RegExp(STYLE_CODE_REGEX);

/// The string used for [controlCodeRegExp]
const String CONTROL_CODE_REGEX = r'\x1B\[[0-9;?]*[A-Za-ln-z]|\x1B[^\[]';
