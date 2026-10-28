import 'package:cmdline/cmdline.dart';
import 'package:test/test.dart';

Cli _makeCli() => Cli(
  name: 'todo',
  version: '1.0.0',
  flags: [Flag('verbose', short: 'v')],
  commands: [
    Command(
      name: 'add',
      about: 'Add a task',
      options: [
        Option('text', short: 't', required: true, help: 'What to do'),
        Option('tag', multiple: true),
        Option('priority', allowed: ['low', 'high'], defaultValue: 'low'),
      ],
      flags: [
        Flag('urgent', short: 'u'),
        Flag('color', negatable: true, defaultValue: true),
        Flag('secret', hidden: true),
      ],
      run: (_) {},
    ),
    Command(
      name: 'list',
      aliases: ['ls'],
      flags: [Flag('all', short: 'a')],
      run: (_) {},
    ),
  ],
);

ParseResult _parse(List<String> arguments) =>
    Parser(_makeCli(), arguments).parse();

void main() {
  group('options', () {
    test('accept every way of giving a value', () {
      expect(_parse(['add', '--text', 'a']).input.option('text'), 'a');
      expect(_parse(['add', '--text=a b']).input.option('text'), 'a b');
      expect(_parse(['add', '-t', 'a']).input.option('text'), 'a');
      expect(_parse(['add', '-ta']).input.option('text'), 'a');
    });

    test('use the default when not given', () {
      final input = _parse(['add', '-t', 'a']).input;
      expect(input.option('priority'), 'low');
      expect(input.wasGiven('priority'), isFalse);
      expect(input.options('tag'), isEmpty);
    });

    test('collect repeated values when multiple', () {
      final input = _parse(['add', '-t', 'a', '--tag', 'x', '--tag', 'y'])
          .input;
      expect(input.options('tag'), ['x', 'y']);
    });

    test('reject values that are not allowed', () {
      expect(
        () => _parse(['add', '-t', 'a', '--priority', 'mid']),
        throwsA(isA<CliError>()),
      );
    });

    test('fail when required is missing', () {
      expect(() => _parse(['add']), throwsA(isA<CliError>()));
    });

    test('fail when the value is missing', () {
      expect(() => _parse(['add', '--text']), throwsA(isA<CliError>()));
    });
  });

  group('flags', () {
    test('work long, short and grouped', () {
      final input = _parse(['add', '-t', 'a', '-uv']).input;
      expect(input.flag('urgent'), isTrue);
      expect(input.flag('verbose'), isTrue);
      expect(
        _parse(['add', '-t', 'a', '--urgent']).input.flag('urgent'),
        isTrue,
      );
    });

    test('are false by default', () {
      expect(_parse(['add', '-t', 'a']).input.flag('urgent'), isFalse);
    });

    test('can be turned off with --no- when negatable', () {
      final input = _parse(['add', '-t', 'a', '--no-color']).input;
      expect(input.flag('color'), isFalse);
      expect(
        () => _parse(['add', '-t', 'a', '--no-urgent']),
        throwsA(isA<CliError>()),
      );
    });

    test('reject a value', () {
      expect(
        () => _parse(['add', '-t', 'a', '--urgent=yes']),
        throwsA(isA<CliError>()),
      );
    });
  });

  group('commands', () {
    test('are picked by name and alias', () {
      expect(_parse(['list']).command.name, 'list');
      expect(_parse(['ls', '-a']).input.flag('all'), isTrue);
      expect(_parse(['ls']).input.commandPath, ['todo', 'list']);
    });

    test('see flags from parent commands', () {
      expect(_parse(['list', '-v']).input.flag('verbose'), isTrue);
    });

    test('fail on an unknown command when the parent has no run', () {
      expect(() => _parse(['remove']), throwsA(isA<CliError>()));
    });

    test('put leftover words and everything after -- into rest', () {
      final input = _parse(['list', 'a', 'b', '--', '-x', '--y']).input;
      expect(input.rest, ['a', 'b', '-x', '--y']);
    });
  });

  group('help and version', () {
    test('skip the required check', () {
      expect(_parse(['add', '--help']).helpWanted, isTrue);
      expect(_parse(['add', '-h']).helpWanted, isTrue);
      expect(_parse(['help', 'add']).command.name, 'add');
      expect(_parse(['--version']).versionWanted, isTrue);
    });

    test('help lists visible options and hides hidden ones', () {
      final cli = _makeCli();
      final text = HelpPrinter([cli, cli.findCommand('add')!]).build();
      expect(text, contains('--text <text>'));
      expect(text, contains('--[no-]color'));
      expect(text, contains('--verbose'));
      expect(text, isNot(contains('--secret')));
    });
  });

  group('building', () {
    test('rejects duplicate names', () {
      expect(
        () => Command(name: 'x', flags: [Flag('a'), Flag('a')]),
        throwsArgumentError,
      );
    });

    test('rejects long short names', () {
      expect(
        () => Command(
          name: 'x',
          flags: [Flag('a', short: 'ab')],
        ),
        throwsArgumentError,
      );
    });

    test('input rejects names that were never declared', () {
      expect(() => _parse(['list']).input.flag('nope'), throwsArgumentError);
    });
  });
}
