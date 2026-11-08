import 'dart:io';

import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for ANSI styling: text styles, colours and terminal escapes.
class AnsiDemo {
  const AnsiDemo._();

  /// Runs every ANSI demo in turn.
  static Future<void> all() async {
    await section('Text styles', styles);
    await section('Colours', colours);
    await section('Terminal escapes', escapes);
  }

  /// Shows every style getter, the raw code constants, and helpers to look
  /// inside styled text.
  static void styles() {
    heading('String getters');
    final getters = {
      'bold': 'bold'.bold,
      'dim': 'dim'.dim,
      'italic': 'italic'.italic,
      'underline': 'underline'.underline,
      'doublyUnderline': 'double'.doublyUnderline,
      'curlyUnderline': 'curly'.curlyUnderline.underlineColour(
        AnsiPalette.rose,
      ),
      'dottedUnderline': 'dotted'.dottedUnderline,
      'dashedUnderline': 'dashed'.dashedUnderline,
      'overline': 'overline'.overline,
      'strikethrough': 'strike'.strikethrough,
      'inverse': 'inverse'.inverse,
      'blink': 'blink'.blink,
      'invisible': 'invisible'.invisible,
      'frame': 'frame'.frame,
      'encircle': 'encircle'.encircle,
      'fraktur': 'fraktur'.fraktur,
      'superscript': 'super'.superscript,
      'subscript': 'sub'.subscript,
    };
    AnsiTheme.say(
      CMD.draw.table(
        [
          for (final entry in getters.entries) ['.${entry.key}', entry.value],
        ],
        header: ['Getter', 'Looks like'],
      ),
    );
    AnsiTheme.say('Not every terminal shows every style.'.dim);

    heading('Mixing styles');
    AnsiTheme.say(
      'bold, italic and sky blue'.bold.italic.foreground(AnsiPalette.sky),
    );
    AnsiTheme.say(' on a background '.background(AnsiPalette.lavender));
    AnsiTheme.say('a link to dart.dev'.underline.link('https://dart.dev'));

    heading('Raw code constants');
    AnsiTheme.say(
      '$BOLD${UNDERLINE}BOLD + UNDERLINE$RESET  $ITALIC${DIM}ITALIC + DIM$RESET',
    );
    AnsiTheme.say(
      '${ANSI_HIGH_GREEN_FG}ANSI_HIGH_GREEN_FG$RESET  ${RGB_045_FG}RGB_045_FG$RESET',
    );

    heading('AnsiPrinter');
    AnsiPrinter([BOLD, 'Total: ', RESET, 42, ' items'.dim]).output();

    heading('Looking inside styled text');
    final styled = 'Done'.bold.foreground(const AnsiColour(10));
    showCalls([
      ['styled', styled],
      ['Ansi(styled).visible', Ansi(styled).visible],
      ['styled.plain', styled.plain],
      ['styled.length', styled.length],
      ['styled.plain.length', styled.plain.length],
    ]);
  }

  /// Shows the 256-colour table, greys, the palette, RGB and blending.
  static void colours() {
    heading('The 16 basic colours: AnsiColour(0..15)');
    AnsiTheme.say(
      [for (var i = 0; i < 16; i++) '  '.background(AnsiColour(i))].join(),
    );

    heading('The 6x6x6 cube: AnsiColour.rgb(r, g, b)');
    for (var green = 0; green < 6; green++) {
      final row = StringBuffer();
      for (var red = 0; red < 6; red++) {
        for (var blue = 0; blue < 6; blue++) {
          row.write(' '.background(AnsiColour.rgb(red, green, blue)));
        }
        row.write(' ');
      }
      AnsiTheme.say(row.toString());
    }

    heading('Greys: AnsiColour.grey(0..23)');
    AnsiTheme.say(
      [for (var i = 0; i < 24; i++) ' '.background(AnsiColour.grey(i))].join(),
    );

    heading('AnsiPalette');
    final palette = <String, AnsiInk>{
      'orchid': AnsiPalette.orchid,
      'mint': AnsiPalette.mint,
      'brick': AnsiPalette.brick,
      'leaf': AnsiPalette.leaf,
      'amber': AnsiPalette.amber,
      'snow': AnsiPalette.snow,
      'silver': AnsiPalette.silver,
      'ink': AnsiPalette.ink,
      'sky': AnsiPalette.sky,
      'lavender': AnsiPalette.lavender,
      'rose': AnsiPalette.rose,
      'peach': AnsiPalette.peach,
      'butter': AnsiPalette.butter,
      'aqua': AnsiPalette.aqua,
      'slate': AnsiPalette.slate,
    };
    final names = palette.keys.toList();
    for (var row = 0; row < names.length; row += 5) {
      AnsiTheme.say(
        [
          for (final name in names.skip(row).take(5))
            '${'██'.foreground(palette[name]!)} ${name.padRight(9)}',
        ].join(' '),
      );
    }

    heading('True colour: AnsiColourRgb and AnsiColourRgb.hex');
    AnsiTheme.say(
      '${'AnsiColourRgb(255, 128, 0)'.foreground(
          const AnsiColourRgb(255, 128, 0))}  '
          '${'AnsiColourRgb.hex(0x4FC3F7)'.foreground(
          const AnsiColourRgb.hex(0x4FC3F7))}',
    );

    heading('Blending: sky.opacity(amount, over: rose)');
    const width = 48;
    AnsiTheme.say(
      [
        for (var i = 0; i < width; i++)
          ' '.background(
            AnsiPalette.sky.opacity(
              1 - i / (width - 1),
              over: AnsiPalette.rose,
            ),
          ),
      ].join(),
    );
  }

  /// Shows links, the window title, taskbar progress, cursor moves and the
  /// box character sets.
  static Future<void> escapes() async {
    heading('Hyperlinks');
    AnsiTheme.say(
      hyperlink('https://pub.dev/packages/cmdline', 'cmdline on pub.dev'),
    );

    heading('Window title and taskbar');
    stdout.write(windowTitle('cmdline demo'));
    log('The window title is now "cmdline demo"');
    for (var percent = 0; percent <= 100; percent += 20) {
      stdout.write(taskbarProgress(percent));
      await delay(0.15);
    }
    stdout.write(TASKBAR_CLEAR);
    log('The taskbar showed progress (Windows Terminal and some others)');

    heading('Cursor moves');
    stdout.write('Counting: ');
    for (var i = 1; i <= 5; i++) {
      stdout.write('$SAVE_CURSOR$i$RESTORE_CURSOR');
      await delay(0.2);
    }
    stdout.writeln();
    stdout.writeln('first line');
    stdout.writeln('second line');
    stdout.write(
      '${cursorUp(2)}${cursorToColumn(14)}${'<- written later'.dim}',
    );
    stdout.write(cursorDown(2));
    stdout.write(cursorToColumn(1));

    heading('Box characters');
    final presets = {
      'light': BoxChars.light,
      'heavy': BoxChars.heavy,
      'doubleLine': BoxChars.doubleLine,
      'rounded': BoxChars.rounded,
      'ansi': BoxChars.ansi,
    };
    final start = AnsiTheme.current;
    try {
      for (final entry in presets.entries) {
        AnsiTheme.current = AnsiTheme(box: entry.value);
        AnsiTheme.say(CMD.draw.box('BoxChars.${entry.key}'));
      }
    } finally {
      AnsiTheme.current = start;
    }

    heading('Symbols');
    AnsiTheme.say(
      [
        TICK,
        CROSS,
        WARNING,
        INFO,
        ARROW,
        BULLET,
        ELLIPSIS,
        FULL_BLOCK,
        DARK_SHADE,
        MEDIUM_SHADE,
        LIGHT_SHADE,
      ].join('  '),
    );
  }
}
