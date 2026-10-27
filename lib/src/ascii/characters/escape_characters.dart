// ignore_for_file: constant_identifier_names

/// The raw building blocks every code in this package is assembled from.
///
/// A styled string is nothing more than `CSI` + parameters + `SGR`, so these
/// six constants are enough to hand-roll any code the palettes do not cover.

/// Escape. Opens every escape sequence.
const String ESC = '\x1B';

const String newline = '\n';

/// Control Sequence Introducer. Opens every sequence this package writes.
const String CSI = '$ESC[';

/// Foreground colour open, 256-colour table.
///
/// Template: `$FGCO<index>$SGR`, where `<index>` is `0`-`255`.
const String FGCO =  '${CSI}38;5;';

/// Background colour open, 256-colour table.
///
/// Template: `$BGCO<index>$SGR`, where `<index>` is `0`-`255`.
const String BGCO = '${CSI}48;5;';

/// Underline colour open, 256-colour table.
///
/// Template: `$ULCO<index>$SGR`, where `<index>` is `0`-`255`.
const String ULCO = '${CSI}58;5;';

/// Select Graphic Rendition. Closes every sequence this package writes.
const String SGR = 'm';

/// Clears every colour and style set so far — `CSI 0 SGR`.
///
/// Terminals hold a style until something clears it, so a string that opens
/// one and never closes it bleeds into whatever is printed next. Append this
/// to the end of anything styled; `AsciiPrinter` and `Ascii.output()` do it
/// for you.
const String reset = '${CSI}0$SGR';
