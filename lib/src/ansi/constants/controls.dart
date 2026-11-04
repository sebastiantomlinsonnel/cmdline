/// The escape character that starts every terminal control sequence.
///
/// Byte `0x1B`. On its own it does nothing visible; the characters after it
/// tell the terminal what to do. Most codes in this library start with [CSI],
/// which is this character followed by `[`.
const String ESC = '\x1B';

/// A line break.
///
/// Plain `\n`. Kept as a constant so multi-line output built from codes reads
/// the same way as the rest of the sequences.
const String NEWLINE = '\n';

/// The Control Sequence Introducer that starts most escape codes.
///
/// [ESC] followed by `[`. A full style code is `CSI`, then the parameters,
/// then a final letter, e.g. `${CSI}1$SGR` turns on bold.
const String CSI = '$ESC[';

/// Start of a 256-colour text (foreground) code; add an index and [SGR].
///
/// `${CSI}38;5;`. Append a palette index from 0 to 255 and [SGR] to finish it:
/// `'${FGCO}196$SGR'` makes the text bright red. The ready-made `*_FG`
/// constants and [AnsiColour.fg] do the same thing.
const String FGCO = '${CSI}38;5;';

/// Start of a 256-colour background code; add an index and [SGR].
///
/// `${CSI}48;5;`. Append a palette index from 0 to 255 and [SGR] to finish it:
/// `'${BGCO}21$SGR'` gives a blue background. The ready-made `*_BG` constants
/// and [AnsiColour.bg] do the same thing.
const String BGCO = '${CSI}48;5;';

/// Start of a 256-colour underline-colour code; add an index and [SGR].
///
/// `${CSI}58;5;`. Append a palette index from 0 to 255 and [SGR] to finish it.
/// It only shows while an underline style is on, and not every terminal
/// supports coloured underlines. [AnsiColour.underline] builds the same code.
const String ULCO = '${CSI}58;5;';

/// The final letter that ends a style (Select Graphic Rendition) code.
///
/// `m`. Every style and colour code in this library has the form
/// `CSI <parameters> SGR`, e.g. `${CSI}3$SGR` for italic.
const String SGR = 'm';

/// Turns off every style and colour.
///
/// `${CSI}0m`. Puts the terminal back to its default text. Printing helpers
/// such as [Ansi.toString], [AnsiPrinter] and [AnsiStyledString] add it at
/// the end so a style never leaks into the next line.
const String RESET = '${CSI}0$SGR';

/// Clears line
const String CLEAR_LINE = '\r\x1B[2K';
