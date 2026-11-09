import 'package:cmdline/cmdline.dart';
import 'package:cmdline/testing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() => AnsiTheme.useColour = false);

  group('Spinner', () {
    test('animates, logs above itself and ends with a tick', () async {
      final terminal = MockTerminal();
      await Terminal.use(terminal, () async {
        final spinner = Spinner('Working', interval: const Duration(milliseconds: 5)).start();
        await Future<void>.delayed(const Duration(milliseconds: 30));
        spinner.log('step one done');
        spinner.pass('All done');
      });
      expect(terminal.screen.first, 'step one done');
      expect(terminal.screen.last, startsWith('✔ All done ('));
      expect(terminal.screen, hasLength(2));
    });

    test('run gives back the result, and rethrows errors', () async {
      final terminal = MockTerminal();
      final value = await Terminal.use(terminal, () => Spinner.run('Fetch', () async => 42));
      expect(value, 42);
      await expectLater(
        Terminal.use(terminal, () => Spinner.run<void>('Boom', () async => throw StateError('no'))),
        throwsStateError,
      );
      expect(terminal.screen.last, contains('✖ Boom: Bad state: no'));
    });

    test('piped output only gets the final line', () async {
      final terminal = MockTerminal(interactive: false);
      await Terminal.use(terminal, () async {
        final spinner = Spinner('Working').start();
        await Future<void>.delayed(const Duration(milliseconds: 20));
        spinner.fail('Nope');
      });
      expect(terminal.output, isNot(contains('\x1B[')));
      expect(terminal.screen, [startsWith('✖ Nope')]);
    });
  });

  group('Tasks', () {
    test('runs tasks, reports failures and keeps going', () async {
      final terminal = MockTerminal();
      final reports = await Terminal.use(
        terminal,
        () => Tasks.run([
          Task('Download', (task) async {
            for (var i = 1; i <= 3; i++) {
              await Future<void>.delayed(const Duration(milliseconds: 5));
              task.progress(i, 3);
            }
          }),
          Task('Build', (task) async {
            task.update('compiling');
            throw Exception('compiler crashed');
          }),
          Task('Upload', (task) async {}),
        ], concurrency: 2),
      );
      expect([for (final r in reports) r.ok], [true, false, true]);
      final screen = terminal.screen;
      expect(screen, hasLength(3));
      expect(screen[0], startsWith('✔ Download'));
      expect(screen[1], contains('✖ Build Exception: compiler crashed'));
      expect(screen[2], startsWith('✔ Upload'));
    });

    test('piped output prints one line per finished task', () async {
      final terminal = MockTerminal(interactive: false);
      await Terminal.use(
        terminal,
        () => Tasks.run([Task('A', (_) async {}), Task('B', (_) async {})]),
      );
      expect(terminal.output, isNot(contains('\x1B[')));
      expect(terminal.screen, [startsWith('✔ A'), startsWith('✔ B')]);
    });
  });

  test('ProgressBar draws nothing when piped', () {
    final terminal = MockTerminal(interactive: false);
    Terminal.use(terminal, () {
      ProgressBar('Copy', total: 3)
        ..add()
        ..add();
    });
    expect(terminal.output, isEmpty);
  });
}
