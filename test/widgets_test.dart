import 'package:cmdline/cmdline.dart';
import 'package:cmdline/testing.dart';
import 'package:test/test.dart';

/// [text] without styles, split into lines.
List<String> plain(String text) => text.plain.split('\n');

void main() {
  test('box lines up wide characters', () {
    expect(plain(Widgets.box('日本\nab')), [
      '╭──────╮',
      '│ 日本 │',
      '│ ab   │',
      '╰──────╯',
    ]);
  });

  test('table shrinks and wraps to fit', () {
    final table = Terminal.use(MockTerminal(columns: 30), () => Widgets.table(
      [['short', 'a long description that will not fit on one line']],
      header: ['Name', 'About'],
    ));
    final lines = plain(table);
    expect(lines.every((line) => line.width <= 30), isTrue);
    expect(lines.length, greaterThan(5));
    expect(lines.join(' '), contains('description'));
  });

  test('table cuts cells when wrap is off', () {
    final lines = plain(Widgets.table([['abcdefghij']], maxWidth: 9, wrap: false));
    expect(lines[1], '│ abcd… │');
  });

  test('table keeps right alignment', () {
    final lines = plain(Widgets.table([['a', 5], ['b', 100]], rightAligned: {1}));
    expect(lines[1], '│ a │   5 │');
  });

  test('keyValue lines up keys', () {
    expect(plain(Widgets.keyValue({'Name': 'app', 'Version': '1.0'})), [
      'Name     app',
      'Version  1.0',
    ]);
  });

  test('tree draws branches', () {
    expect(
      plain(Widgets.tree([
        const TreeNode('lib', [
          TreeNode('src', [TreeNode('cli.dart')]),
          TreeNode('cmdline.dart'),
        ]),
      ])),
      ['lib', '├─ src', '│  ╰─ cli.dart', '╰─ cmdline.dart'],
    );
  });

  test('bullets wrap under their text', () {
    final lines = Terminal.use(
      MockTerminal(columns: 20),
      () => plain(Widgets.bullets(['one two three four five six'], numbered: true)),
    );
    expect(lines, ['1. one two three', '   four five six']);
  });

  test('rule spans the given width', () {
    expect(Widgets.rule(title: 'Hi', width: 12).plain, '── Hi ──────');
    expect(Widgets.rule(width: 5).plain, '─────');
  });

  test('callout shows the tone', () {
    final text = Widgets.callout('Careful', tone: Tone.warn).plain;
    expect(text, contains('⚠ Warning'));
    expect(text, contains('Careful'));
  });

  test('hotkeys line up', () {
    expect(plain(Widgets.hotkeys([('↑↓', 'move'), ('enter', 'open')])), [
      '  ↑↓     move',
      '  enter  open',
    ]);
  });
}
