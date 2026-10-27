import 'package:cmdline/cmdline.dart';

enum Level { log, warn, pass, fail, debug, trace, dev }

enum DevType {
  message,
  error,
  pass;

  static String getDevType(DevType type, bool blink) {
    String string = blink ? '$BLINK_RAPID⬤ DEV $RESET_BLINK' : '⬤ DEV ';
    return switch (type) {
      DevType.message =>
        '${string.foreground(const AsciiColourRgb.hex(0xFF77FF)).bold.background(const AsciiColorRgb.hex(0x2A2A70))}$RESET_BOLD_AND_DIM$RESET_BLINK',
      DevType.error =>
        BLINK_RAPID +
            '$RED_FG$string$RESET_FG'.bold.background(
              const AsciiColorRgb.hex(0x2A2A70),
            ) +
            RESET_BOLD_AND_DIM +
            RESET_BLINK,
      DevType.pass =>
        BLINK_RAPID +
            '$GREEN_FG$string$RESET_FG'.bold.background(
              const AsciiColorRgb.hex(0x2A2A70),
            ) +
            RESET_BOLD_AND_DIM +
            RESET_BLINK,
    };
  }
}
