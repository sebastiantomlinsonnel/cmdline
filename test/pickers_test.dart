import 'dart:io';

import 'package:cmdline/cmdline.dart';
import 'package:cmdline/testing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() => AnsiTheme.useColour = false);
  tearDown(() => PromptMode.current = null);

  group('Fuzzy', () {
    test('matches letters in order and prefers word starts', () {
      expect(Fuzzy.match('gco', 'git checkout'), isNotNull);
      expect(Fuzzy.match('xyz', 'git checkout'), isNull);
      final start = Fuzzy.match('ch', 'git checkout')!.score;
      final middle = Fuzzy.match('ch', 'git fetch')!.score;
      expect(start, greaterThan(middle));
    });
  });

  test('search filters and picks the best match', () {
    final terminal = MockTerminal()
      ..type('build')
      ..press(Key.enter);
    final picked = terminal.run(
      () => Prompts.search('Run', ['git commit', 'go build', 'grep']),
    );
    expect(picked, 'go build');
  });

  test('search results move with arrows and Ctrl+N/Ctrl+P', () {
    final arrows = MockTerminal()
      ..type('g')
      ..press(Key.down)
      ..press(Key.enter);
    // Best match first: go, git, grep.
    expect(arrows.run(() => Prompts.search('Run', ['git', 'go', 'grep'])), 'git');

    final ctrl = MockTerminal()
      ..type('g')
      ..ctrl('n')
      ..ctrl('n')
      ..ctrl('p')
      ..press(Key.enter);
    expect(ctrl.run(() => Prompts.search('Run', ['git', 'go', 'grep'])), 'git');
  });

  test('search Esc clears the query first', () {
    final terminal = MockTerminal()
      ..type('zzz')
      ..press(Key.escape)
      ..press(Key.enter);
    expect(terminal.run(() => Prompts.search('Run', ['a', 'b'])), 'a');
  });

  test('tags add, complete and remove', () {
    final terminal = MockTerminal()
      ..type('bug,')
      ..type('fe')
      ..press(Key.tab)
      ..type('oops')
      ..press(Key.enter)
      ..press(Key.backspace)
      ..press(Key.enter);
    final tags = terminal.run(
      () => Prompts.tags('Labels', suggestions: ['bug', 'feature']),
    );
    expect(tags, ['bug', 'feature']);
  });

  test('tags refuse new words when allowNew is off', () {
    final terminal = MockTerminal()
      ..type('nope')
      ..press(Key.enter)
      ..press(Key.backspace, times: 4)
      ..press(Key.enter);
    terminal.run(
      () => Prompts.tags('Labels', suggestions: ['bug'], allowNew: false),
    );
    expect(terminal.output, contains("isn't one of the choices"));
  });

  test('grid moves in two directions', () {
    final terminal = MockTerminal()
      ..press(Key.down)
      ..press(Key.right)
      ..press(Key.enter);
    final size = terminal.run(
      () => Prompts.grid('Size', ['XS', 'S', 'M', 'L', 'XL', 'XXL'], columns: 3),
    );
    expect(size, 'XL');
  });

  test('toggles flip switches', () {
    final terminal = MockTerminal()
      ..press(Key.left)
      ..press(Key.down)
      ..press(Key.right)
      ..press(Key.enter);
    final result = terminal.run(
      () => Prompts.toggles('Settings', {'Dark': true, 'Telemetry': false}),
    );
    expect(result, {'Dark': false, 'Telemetry': true});
  });

  test('slider moves and stays in range', () {
    final terminal = MockTerminal()
      ..press(Key.right, times: 50)
      ..press(Key.enter);
    expect(terminal.run(() => Pickers.slider('Volume', max: 10, start: 5)), 10);
  });

  test('range moves both ends', () {
    final terminal = MockTerminal()
      ..press(Key.right, times: 2)
      ..press(Key.tab)
      ..press(Key.left)
      ..press(Key.enter);
    final picked = terminal.run(() => Pickers.range('Price', max: 10));
    expect(picked, (start: 2, end: 9));
  });

  test('rating number keys answer straight away', () {
    final terminal = MockTerminal()..type('4');
    expect(terminal.run(() => Pickers.rating('Stars')), 4);
  });

  group('date', () {
    test('moves by days, weeks and months', () {
      final terminal = MockTerminal()
        ..press(Key.right)
        ..press(Key.down)
        ..press(Key.pageDown)
        ..press(Key.enter);
      final day = terminal.run(() => Pickers.date('Due', start: DateTime(2026, 1, 30)));
      // 30 Jan + 1 day + 1 week = 7 Feb, + 1 month = 7 Mar.
      expect(day, DateTime(2026, 3, 7));
    });

    test('a month jump keeps the day inside the month', () {
      final terminal = MockTerminal()
        ..press(Key.pageDown)
        ..press(Key.enter);
      expect(
        terminal.run(() => Pickers.date('Due', start: DateTime(2026, 1, 31))),
        DateTime(2026, 2, 28),
      );
    });

    test('stays inside first and last', () {
      final terminal = MockTerminal()
        ..press(Key.left, times: 10)
        ..press(Key.enter);
      final day = terminal.run(
        () => Pickers.date('Due', start: DateTime(2026, 5, 5), first: DateTime(2026, 5, 1)),
      );
      expect(day, DateTime(2026, 5, 1));
    });

    test('line mode reads yyyy-mm-dd', () {
      final terminal = MockTerminal(interactive: false)
        ..line('2026-02-30')
        ..line('2026-02-03');
      expect(terminal.run(() => Pickers.date('Due')), DateTime(2026, 2, 3));
      expect(terminal.output, contains("That day doesn't exist"));
    });
  });

  group('files', () {
    late Directory folder;
    setUp(() {
      folder = Directory.systemTemp.createTempSync('cmdline_picker_');
      Directory('${folder.path}/src').createSync();
      File('${folder.path}/src/main.dart').writeAsStringSync('');
      File('${folder.path}/readme.md').writeAsStringSync('');
    });
    tearDown(() => folder.deleteSync(recursive: true));

    test('file picker opens folders and picks a file', () {
      final terminal = MockTerminal()
        // Rows: .., src/, readme.md
        ..press(Key.down)
        ..press(Key.enter)
        ..press(Key.down)
        ..press(Key.enter);
      final picked = terminal.run(() => Pickers.file('Pick', folder: folder.path));
      expect(picked, endsWith('main.dart'));
    });

    test('file picker filters by typing', () {
      final terminal = MockTerminal()
        ..type('read')
        ..press(Key.enter);
      expect(
        terminal.run(() => Pickers.file('Pick', folder: folder.path)),
        endsWith('readme.md'),
      );
    });

    test('folder picker uses the open folder', () {
      final terminal = MockTerminal()..press(Key.enter);
      final picked = terminal.run(
        () => Pickers.file('Pick', folder: folder.path, kind: PathKind.folder),
      );
      expect(Directory(picked).absolute.path, Directory(folder.path).absolute.path);
    });

    test('path completes with Tab', () {
      final terminal = MockTerminal()
        ..type('${folder.path}${Platform.pathSeparator}rea')
        ..press(Key.tab)
        ..press(Key.enter);
      expect(terminal.run(() => Pickers.path('Path')), endsWith('readme.md'));
    });

    test('path refuses missing files', () {
      final terminal = MockTerminal()
        ..type('${folder.path}/nope')
        ..press(Key.enter)
        ..press(Key.escape);
      expect(() => terminal.run(() => Pickers.path('Path')), throwsA(isA<PromptCancelled>()));
      expect(terminal.output, contains('Nothing at'));
    });
  });

  test('colour picks from the grid or a hex code', () {
    final grid = MockTerminal()..press(Key.enter);
    expect(grid.run(() => Pickers.colour('Accent')), isA<AnsiColourRgb>());

    final hex = MockTerminal()
      ..type('#ff8800')
      ..press(Key.enter);
    expect(hex.run(() => Pickers.colour('Accent')), const AnsiColourRgb(255, 136, 0));
  });

  test('pickers take defaults when unattended', () {
    final terminal = MockTerminal(interactive: false);
    Terminal.use(terminal, () {
      PromptMode.current = PromptMode.unattended;
      expect(Pickers.slider('Volume', start: 30), 30);
      expect(Pickers.rating('Stars', start: 2), 2);
      expect(Pickers.date('Due', start: DateTime(2026, 1, 2)), DateTime(2026, 1, 2));
      expect(Prompts.toggles('S', {'a': true}), {'a': true});
      expect(() => Pickers.file('Pick'), throwsA(isA<PromptCancelled>()));
    });
  });
}
