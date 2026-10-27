part of '../ascii.dart';

const String ESC = '\x1B';

const String NEWLINE = '\n';

const String CSI = '$ESC[';

const String FGCO = '${CSI}38;5;';

const String BGCO = '${CSI}48;5;';

const String ULCO = '${CSI}58;5;';

const String SGR = 'm';

const String RESET = '${CSI}0$SGR';
