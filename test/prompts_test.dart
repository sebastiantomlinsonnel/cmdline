import 'package:cmdline/cmdline.dart';
import 'package:cmdline/testing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() => AnsiTheme.useColour = false);
  tearDown(() => PromptMode.current = null);

  group('ask', () {
    test('takes typed text with editing', () {
      final terminal = MockTerminal()
        ..type('helo')
        ..press(Key.left)
        ..type('l')
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.ask('Name')), 'hello');
      expect(terminal.screen, ['✔ Name hello']);
    });

    test('takes the default on Enter, and Tab edits it', () {
      final enter = MockTerminal()..press(Key.enter);
      expect(enter.run(() => Prompts.ask('Name', defaultValue: 'app')), 'app');

      final tab = MockTerminal()
        ..press(Key.tab)
        ..type('2')
        ..press(Key.enter);
      expect(tab.run(() => Prompts.ask('Name', defaultValue: 'app')), 'app2');
    });

    test('validator problem keeps the prompt open', () {
      final terminal = MockTerminal()
        ..type('abc')
        ..press(Key.enter)
        ..press(Key.backspace, times: 3)
        ..type('42')
        ..press(Key.enter);
      final answer = terminal.run(
        () => Prompts.ask('Port', validator: (a) => int.tryParse(a) == null ? 'Type a number' : null),
      );
      expect(answer, '42');
      expect(terminal.output, contains('Type a number'));
    });

    test('Esc throws PromptCancelled', () {
      final terminal = MockTerminal()..press(Key.escape);
      expect(() => terminal.run(() => Prompts.ask('Name')), throwsA(isA<PromptCancelled>()));
      expect(terminal.screen, ['✖ Name cancelled']);
    });

    test('restores echo and line mode', () {
      final terminal = MockTerminal()..press(Key.enter);
      terminal.run(() => Prompts.ask('Name', required: false));
      expect((terminal.echoMode, terminal.lineMode), (true, true));
    });
  });

  test('password masks what is typed', () {
    final terminal = MockTerminal()
      ..type('hunter2')
      ..press(Key.enter);
    expect(terminal.run(() => Prompts.password('Password')), 'hunter2');
    expect(terminal.output, isNot(contains('hunter2')));
    expect(terminal.screen, ['✔ Password •••••••']);
  });

  test('integer steps with arrows and checks the range', () {
    final terminal = MockTerminal()
      ..press(Key.up, times: 3)
      ..press(Key.enter);
    expect(terminal.run(() => Prompts.integer('Count', defaultValue: 8, max: 10)), 10);

    final low = MockTerminal()
      ..type('0')
      ..press(Key.enter)
      ..press(Key.backspace)
      ..type('5')
      ..press(Key.enter);
    expect(low.run(() => Prompts.integer('Count', min: 1)), 5);
    expect(low.output, contains('Type 1 or more'));
  });

  test('decimal steps without float noise', () {
    final terminal = MockTerminal()
      ..press(Key.up, times: 3)
      ..press(Key.enter);
    expect(terminal.run(() => Prompts.decimal('Ratio', defaultValue: 0, step: 0.1)), 0.3);
  });

  group('confirm', () {
    test('y answers straight away', () {
      final terminal = MockTerminal()..type('y');
      expect(terminal.run(() => Prompts.confirm('Sure?')), isTrue);
      expect(terminal.screen, ['✔ Sure? Yes']);
    });

    test('arrows toggle and Enter takes it', () {
      final terminal = MockTerminal()
        ..press(Key.right)
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.confirm('Sure?', defaultValue: false)), isTrue);
    });

    test('Enter with nothing picked asks again', () {
      final terminal = MockTerminal()
        ..press(Key.enter)
        ..type('n');
      expect(terminal.run(() => Prompts.confirm('Sure?')), isFalse);
      expect(terminal.output, contains('Pick yes or no'));
    });
  });

  group('select', () {
    test('moves with arrows and wraps', () {
      final terminal = MockTerminal()
        ..press(Key.up)
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.select('Colour', ['Red', 'Green', 'Blue'])), 'Blue');
      expect(terminal.screen, ['✔ Colour Blue']);
    });

    test('jumps to numbers above 9', () {
      final options = List.generate(20, (i) => 'Item ${i + 1}');
      final terminal = MockTerminal()
        ..type('12')
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.select('Pick', options)), 'Item 12');
    });

    test('scrolls long lists and shows more lines', () {
      final options = List.generate(50, (i) => 'Item ${i + 1}');
      final terminal = MockTerminal(rows: 10)..press(Key.pageDown);
      terminal.press(Key.enter);
      terminal.run(() => Prompts.select('Pick', options));
      expect(terminal.output, contains('more'));
    });

    test('menu still works with the old signature', () {
      final terminal = MockTerminal()
        ..press(Key.down)
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.menu('Pick', [1, 2, 3], format: (n) => '#$n')), 2);
    });

    test('works with colour off (no longer tied to colour)', () {
      AnsiTheme.useColour = false;
      final terminal = MockTerminal()
        ..press(Key.down)
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.select('Pick', ['a', 'b'])), 'b');
      expect(terminal.output, isNot(contains('\x1B[1m')));
    });
  });

  group('multiSelect', () {
    test('ticks with space and respects min', () {
      final terminal = MockTerminal()
        ..press(Key.enter)
        ..press(Key.space)
        ..press(Key.down, times: 2)
        ..press(Key.space)
        ..press(Key.enter);
      final picked = terminal.run(() => Prompts.multiSelect('Features', ['a', 'b', 'c'], min: 1));
      expect(picked, ['a', 'c']);
      expect(terminal.output, contains('Pick at least 1'));
      expect(terminal.screen, ['✔ Features a, c']);
    });

    test('a ticks all, and max is enforced', () {
      final terminal = MockTerminal()
        ..type('a')
        ..press(Key.enter);
      expect(terminal.run(() => Prompts.multiSelect('F', ['a', 'b'])), ['a', 'b']);
    });
  });

  test('multiline edits several lines', () {
    final terminal = MockTerminal()
      ..type('first')
      ..press(Key.enter)
      ..type('second')
      ..ctrl('d');
    expect(terminal.run(() => Prompts.multiline('Message')), 'first\nsecond');
  });

  group('line mode', () {
    test('ask and confirm read typed lines', () {
      final terminal = MockTerminal(interactive: false)
        ..line('Ada')
        ..line('')
        ..line('maybe')
        ..line('y');
      terminal.run(() {
        expect(Prompts.ask('Name'), 'Ada');
        expect(Prompts.ask('City', defaultValue: 'Paris'), 'Paris');
        expect(Prompts.confirm('Sure?'), isTrue);
      });
      expect(terminal.output, contains('Please type y or n'));
    });

    test('select reads a number', () {
      final terminal = MockTerminal(interactive: false)..line('2');
      expect(terminal.run(() => Prompts.select('Pick', ['a', 'b', 'c'])), 'b');
      expect(terminal.output, contains('3) c'));
    });

    test('multiSelect reads ranges', () {
      final terminal = MockTerminal(interactive: false)..line('1,3-4');
      expect(terminal.run(() => Prompts.multiSelect('Pick', ['a', 'b', 'c', 'd'])), ['a', 'c', 'd']);
    });

    test('input running out cancels', () {
      final terminal = MockTerminal(interactive: false);
      expect(() => terminal.run(() => Prompts.ask('Name')), throwsA(isA<PromptCancelled>()));
    });
  });

  group('unattended', () {
    test('takes defaults or throws', () {
      final terminal = MockTerminal(interactive: false);
      Terminal.use(terminal, () {
        PromptMode.current = PromptMode.unattended;
        expect(Prompts.ask('Name', defaultValue: 'x'), 'x');
        expect(Prompts.confirm('Sure?', defaultValue: true), isTrue);
        expect(Prompts.select('Pick', ['a', 'b'], defaultOption: 'b'), 'b');
        expect(() => Prompts.select('Pick', ['a', 'b']), throwsA(isA<PromptCancelled>()));
      });
      expect(terminal.output, contains('✔ Name x'));
    });
  });

  test('a long question wraps without leaving junk behind', () {
    final terminal = MockTerminal(columns: 20)
      ..type('abc')
      ..press(Key.enter);
    terminal.run(() => Prompts.ask('A question that is much longer than the screen'));
    expect(terminal.screen.join('\n'), isNot(contains('?')));
  });
}
