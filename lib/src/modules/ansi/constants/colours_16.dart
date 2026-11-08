/// The classic 16 colours, using the shortest and oldest colour codes.
///
/// They look the same as the first 16 palette colours in colours.dart (both
/// follow the terminal theme), but these codes work in even the oldest
/// terminals. Text colours are 30-37 and 90-97; backgrounds are 40-47 and
/// 100-107. Reset with RESET_FG or RESET_BG.
///
/// {@category ansi}
library;

import 'package:cmdline/cmdline.dart';

/// Black text, using the classic code 30.
///
/// {@category ansi constants}
const String ANSI_BLACK_FG = '${CSI}30$SGR';

/// Red text, using the classic code 31.
const String ANSI_RED_FG = '${CSI}31$SGR';

/// Green text, using the classic code 32.
const String ANSI_GREEN_FG = '${CSI}32$SGR';

/// Yellow text, using the classic code 33.
const String ANSI_YELLOW_FG = '${CSI}33$SGR';

/// Blue text, using the classic code 34.
const String ANSI_BLUE_FG = '${CSI}34$SGR';

/// Magenta text, using the classic code 35.
const String ANSI_MAGENTA_FG = '${CSI}35$SGR';

/// Cyan text, using the classic code 36.
const String ANSI_CYAN_FG = '${CSI}36$SGR';

/// White text, using the classic code 37.
const String ANSI_WHITE_FG = '${CSI}37$SGR';

/// Bright black (grey) text, using the classic code 90.
const String ANSI_HIGH_BLACK_FG = '${CSI}90$SGR';

/// Bright red text, using the classic code 91.
const String ANSI_HIGH_RED_FG = '${CSI}91$SGR';

/// Bright green text, using the classic code 92.
const String ANSI_HIGH_GREEN_FG = '${CSI}92$SGR';

/// Bright yellow text, using the classic code 93.
const String ANSI_HIGH_YELLOW_FG = '${CSI}93$SGR';

/// Bright blue text, using the classic code 94.
const String ANSI_HIGH_BLUE_FG = '${CSI}94$SGR';

/// Bright magenta text, using the classic code 95.
const String ANSI_HIGH_MAGENTA_FG = '${CSI}95$SGR';

/// Bright cyan text, using the classic code 96.
const String ANSI_HIGH_CYAN_FG = '${CSI}96$SGR';

/// Bright white text, using the classic code 97.
const String ANSI_HIGH_WHITE_FG = '${CSI}97$SGR';

/// Black background, using the classic code 40.
const String ANSI_BLACK_BG = '${CSI}40$SGR';

/// Red background, using the classic code 41.
const String ANSI_RED_BG = '${CSI}41$SGR';

/// Green background, using the classic code 42.
const String ANSI_GREEN_BG = '${CSI}42$SGR';

/// Yellow background, using the classic code 43.
const String ANSI_YELLOW_BG = '${CSI}43$SGR';

/// Blue background, using the classic code 44.
const String ANSI_BLUE_BG = '${CSI}44$SGR';

/// Magenta background, using the classic code 45.
const String ANSI_MAGENTA_BG = '${CSI}45$SGR';

/// Cyan background, using the classic code 46.
const String ANSI_CYAN_BG = '${CSI}46$SGR';

/// White background, using the classic code 47.
const String ANSI_WHITE_BG = '${CSI}47$SGR';

/// Bright black (grey) background, using the classic code 100.
const String ANSI_HIGH_BLACK_BG = '${CSI}100$SGR';

/// Bright red background, using the classic code 101.
const String ANSI_HIGH_RED_BG = '${CSI}101$SGR';

/// Bright green background, using the classic code 102.
const String ANSI_HIGH_GREEN_BG = '${CSI}102$SGR';

/// Bright yellow background, using the classic code 103.
const String ANSI_HIGH_YELLOW_BG = '${CSI}103$SGR';

/// Bright blue background, using the classic code 104.
const String ANSI_HIGH_BLUE_BG = '${CSI}104$SGR';

/// Bright magenta background, using the classic code 105.
const String ANSI_HIGH_MAGENTA_BG = '${CSI}105$SGR';

/// Bright cyan background, using the classic code 106.
const String ANSI_HIGH_CYAN_BG = '${CSI}106$SGR';

/// Bright white background, using the classic code 107.
const String ANSI_HIGH_WHITE_BG = '${CSI}107$SGR';
