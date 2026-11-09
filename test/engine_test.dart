import 'package:cmdline/cmdline.dart';
import 'package:cmdline/testing.dart';
import 'package:test/test.dart';

/// Reads every key press out of [bytes].
List<String> keysOf(List<int> bytes) {
  final terminal = MockTerminal()..bytes(bytes);
  final reader = KeyReader(terminal);
  final keys = <String>[];
  while (true) {
    final press = reader.read();
    if (press.key == Key.endOfInput) return keys;
    keys.add('$press');
  }
}

void main() {
  setUp(() => AnsiTheme.useColour = false);

  group('KeyReader', () {
    test('reads arrows, Home/End and tilde keys', () {
      expect(
        keysOf('\x1B[A\x1B[B\x1B[C\x1B[D\x1B[H\x1B[F\x1B[3~\x1B[5~\x1B[6~'.codeUnits),
        ['up', 'down', 'right', 'left', 'home', 'end', 'delete', 'pageUp', 'pageDown'],
      );
    });

    test('reads SS3 arrows and Shift+Tab', () {
      expect(keysOf('\x1BOA\x1B[Z'.codeUnits), ['up', 'shift+backTab']);
    });

    test('reads modifiers like Ctrl+Up', () {
      expect(keysOf('\x1B[1;5A\x1B[1;3D\x1B[1;2C'.codeUnits), [
        'ctrl+up',
        'alt+left',
        'shift+right',
      ]);
    });

    test('reads old Windows scan codes', () {
      expect(keysOf([0xE0, 0x48, 0, 0x50]), ['up', 'down']);
    });

    test('reads UTF-8 characters, including ones starting with 0xE0', () {
      final terminal = MockTerminal()..type('é日ࠀ😀');
      final reader = KeyReader(terminal);
      expect([for (var i = 0; i < 4; i++) reader.read().char], ['é', '日', 'ࠀ', '😀']);
    });

    test('Esc followed by a letter gives Esc, then the letter', () {
      expect(keysOf([27, 0x6A]), ['escape', 'char(j)']);
      expect(keysOf([27, 27]), ['escape']);
    });

    test('reads control keys', () {
      expect(keysOf([3, 4, 13, 9, 127]), [
        'ctrl+interrupt',
        'ctrl+ctrl(d)',
        'enter',
        'tab',
        'backspace',
      ]);
    });
  });

  group('TextBuffer', () {
    test('edits around the cursor', () {
      final buffer = TextBuffer('hello world')
        ..handle(const KeyPress(Key.left, ctrl: true))
        ..handle(const KeyPress(Key.backspace))
        ..insert('_');
      expect(buffer.text, 'hello_world');
      buffer.handle(const KeyPress.control('w'));
      expect(buffer.text, 'world');
      buffer
        ..handle(const KeyPress(Key.end))
        ..handle(const KeyPress.control('u'));
      expect(buffer.text, '');
    });

    test('moves over emoji as one character', () {
      final buffer = TextBuffer('a👍🏽b')
        ..handle(const KeyPress(Key.left))
        ..handle(const KeyPress(Key.backspace));
      expect(buffer.text, 'ab');
    });
  });

  group('ListCursor', () {
    test('wraps and scrolls', () {
      final cursor = ListCursor(10, pageSize: 3)..move(-1);
      expect(cursor.index, 9);
      expect((cursor.top, cursor.bottom), (7, 10));
      cursor.handle(const KeyPress(Key.home));
      expect((cursor.index, cursor.top, cursor.moreBelow), (0, 0, true));
    });
  });

  group('DisplayWidth', () {
    test('counts wide characters and ignores styles', () {
      expect('abc'.width, 3);
      expect('日本'.width, 4);
      expect('👍🏽'.width, 2);
      expect('é'.width, 1);
      expect('red'.foreground(const AnsiColour(9)).width, 3);
    });

    test('fits text and keeps styles', () {
      expect('hello world'.fitWidth(6), 'hello…');
      expect('日本語'.fitWidth(5), '日本…');
      expect('hello'.bold.fitWidth(4).plain, 'hel…');
    });

    test('wraps at spaces', () {
      expect('the quick brown fox'.wrapWidth(10), ['the quick', 'brown fox']);
      expect('abcdefghij'.wrapWidth(4), ['abcd', 'efgh', 'ij']);
    });
  });

  group('LiveRegion', () {
    test('wipes wrapped lines when redrawing', () {
      final terminal = MockTerminal(columns: 10);
      LiveRegion(terminal)
        ..draw(['x' * 25, 'second'])
        ..draw(['short']);
      expect(terminal.screen, ['short']);
    });

    test('finish leaves lines behind', () {
      final terminal = MockTerminal();
      terminal.write('before\n');
      LiveRegion(terminal)
        ..draw(['one', 'two', 'three'])
        ..finish(['done']);
      expect(terminal.screen, ['before', 'done']);
    });
  });
}
