import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Called when a command runs. Receives everything that was parsed.
typedef CliRun = FutureOr<void> Function(CliResult result);

class CLI {
  final String name;
  final String description;
  final List<CliCommand> subCommands;
  final List<CliFlag> flags;
  final List<CliOption> options;
  final List<CliArgument> arguments;
  final CliRun run;

  const CLI(
    this.subCommands, {
    this.name = 'cli',
    this.description = '',
    this.flags = const [],
    this.options = const [],
    this.arguments = const [],
    this.run = doNothing,
  });

  /// Parses [args], runs the matching command and returns an exit code.
  Future<int> execute(List<String> args) async {
    final root = CliCommand(
      name: name,
      description: description,
      subCommands: subCommands,
      flags: flags,
      options: options, 
      arguments: arguments,
      run: run,
    );
    final parser = _Parser(root);
    try {
      final result = parser.parse(args);
      if (result == null) {
        stdout.writeln(parser.usage());
        return 0;
      }
      await parser.command.run(result);
      return 0;
    } on CliException catch (e) {
      stderr
        ..writeln('Error: ${e.message}')
        ..writeln()
        ..writeln(parser.usage());
      return 64;
    }
  }
}

class _Parser {
  static const _help = CliFlag(
    'help',
    'Show this help.',
    abbr: 'h',
    negatable: false,
  );

  late CliCommand command;
  final _path = <String>[];
  final _flags = <String, CliFlag>{};
  final _options = <String, CliOption>{};
  final _flagValues = <String, bool>{};
  final _optionValues = <String, List<String>>{};
  final _setByUser = <String>{};

  _Parser(CliCommand root) {
    _flags[_help.name] = _help;
    _flagValues[_help.name] = false;
    _enter(root);
  }

  /// Moves into [c]. Flags and options from parent commands stay valid.
  void _enter(CliCommand c) {
    command = c;
    _path.add(c.name);
    for (final f in c.flags) {
      _flags[f.name] = f;
      _flagValues[f.name] = f.defaultValue;
    }
    for (final o in c.options) {
      _options[o.name] = o;
      _optionValues[o.name] = [if (o.defaultValue != null) o.defaultValue!];
      _setByUser.remove(o.name);
    }
  }

  /// Returns null when help should be shown instead of running.
  CliResult? parse(List<String> args) {
    final positionals = <String>[];
    var onlyPositional = false;
    var i = 0;

    String nextValue(String name) {
      if (i + 1 >= args.length)
        throw CliException('Option "$name" needs a value.');
      return args[++i];
    }

    for (; i < args.length; i++) {
      final arg = args[i];
      if (onlyPositional) {
        positionals.add(arg);
      } else if (arg == '--') {
        onlyPositional = true;
      } else if (arg.startsWith('--')) {
        _long(arg.substring(2), nextValue);
      } else if (arg.startsWith('-') && arg.length > 1) {
        _short(arg.substring(1), nextValue);
      } else {
        final sub = positionals.isEmpty ? command.findSubCommand(arg) : null;
        if (sub != null) {
          _enter(sub);
        } else {
          positionals.add(arg);
        }
      }
    }

    if (_flagValues['help']!) return null;

    if (identical(command.run, doNothing) && command.subCommands.isNotEmpty) {
      if (positionals.isNotEmpty) {
        throw CliException('Unknown command "${positionals.first}".');
      }
      return null; // group command with nothing chosen -> show help
    }

    return CliResult._(
      List.unmodifiable(_path),
      Map.of(_flagValues),
      _optionValues.map((k, v) => MapEntry(k, List.unmodifiable(v))),
      _bindArguments(positionals),
    );
  }

  void _long(String body, String Function(String) nextValue) {
    final eq = body.indexOf('=');
    final name = eq == -1 ? body : body.substring(0, eq);
    final inline = eq == -1 ? null : body.substring(eq + 1);

    final flag = _flags[name];
    if (flag != null) {
      if (inline != null)
        throw CliException('Flag "--$name" does not take a value.');
      _flagValues[flag.name] = true;
      return;
    }
    if (name.startsWith('no-') && inline == null) {
      final negated = _flags[name.substring(3)];
      if (negated != null && negated.negatable) {
        _flagValues[negated.name] = false;
        return;
      }
    }
    final option = _options[name];
    if (option != null) {
      _setOption(option, inline ?? nextValue('--$name'));
      return;
    }
    throw CliException('Unknown option "--$name".');
  }

  /// Handles `-v`, grouped `-abc`, `-t web`, `-tweb` and `-t=web`.
  void _short(String body, String Function(String) nextValue) {
    for (var j = 0; j < body.length; j++) {
      final c = body[j];
      final flag = _flags.values.where((f) => f.abbr == c).firstOrNull;
      if (flag != null) {
        _flagValues[flag.name] = true;
        continue;
      }
      final option = _options.values.where((o) => o.abbr == c).firstOrNull;
      if (option != null) {
        var rest = body.substring(j + 1);
        if (rest.startsWith('=')) rest = rest.substring(1);
        _setOption(option, rest.isNotEmpty ? rest : nextValue('-$c'));
        return;
      }
      throw CliException('Unknown option "-$c".');
    }
  }

  void _setOption(CliOption option, String value) {
    final allowed = option.allowed;
    if (allowed != null && !allowed.contains(value)) {
      throw CliException(
        '"$value" is not allowed for --${option.name}. Allowed: ${allowed.join(', ')}.',
      );
    }
    final values = _optionValues[option.name]!;
    // First user value replaces the default; single options keep only the last.
    if (_setByUser.add(option.name) || !option.multiple) values.clear();
    values.add(value);
  }

  Map<String, List<String>> _bindArguments(List<String> positionals) {
    final result = <String, List<String>>{};
    var i = 0;
    for (final a in command.arguments) {
      if (a.variadic) {
        result[a.name] = List.unmodifiable(positionals.sublist(i));
        i = positionals.length;
      } else {
        result[a.name] = [if (i < positionals.length) positionals[i++]];
      }
      if (a.required && result[a.name]!.isEmpty) {
        throw CliException('Missing argument <${a.name}>.');
      }
    }
    if (i < positionals.length) {
      throw CliException('Unexpected argument "${positionals[i]}".');
    }
    return result;
  }

  // ---- Help text ----------------------------------------------------------

  String usage() {
    final c = command;
    final b = StringBuffer();
    final subs = c.subCommands.where((s) => !s.hidden).toList();

    if (c.description.isNotEmpty)
      b
        ..writeln(c.description)
        ..writeln();

    final argParts = c.arguments.map((a) {
      final n = a.variadic ? '${a.name}...' : a.name;
      return a.required ? '<$n>' : '[$n]';
    });
    b.write(
      'Usage: ${[..._path, if (subs.isNotEmpty) '<command>', '[options]', ...argParts].join(' ')}',
    );

    _section(b, 'Commands', {
      for (final s in subs) [s.name, ...s.aliases].join(', '): s.description,
    });

    _section(b, 'Arguments', {
      for (final a in c.arguments) a.name: a.description,
    });

    _section(b, 'Options', {
      for (final f in _flags.values)
        '${_abbr(f.abbr)}--${f.negatable ? '[no-]' : ''}${f.name}':
            f.description + (f.defaultValue ? ' (default: on)' : ''),
      for (final o in _options.values)
        '${_abbr(o.abbr)}--${o.name}=<${o.valueName}>': [
          o.description,
          if (o.allowed != null) '[${o.allowed!.join(', ')}]',
          if (o.defaultValue != null) '(default: ${o.defaultValue})',
          if (o.multiple) '(repeatable)',
        ].join(' '),
    });

    return b.toString();
  }

  static String _abbr(String? a) => a == null ? '    ' : '-$a, ';

  static void _section(StringBuffer b, String title, Map<String, String> rows) {
    if (rows.isEmpty) return;
    final width = rows.keys
        .map((k) => k.length)
        .reduce((a, b) => a > b ? a : b);
    b
      ..writeln()
      ..writeln()
      ..write('$title:');
    rows.forEach(
      (k, v) => b
        ..writeln()
        ..write('  ${k.padRight(width)}  $v'),
    );
  }
}

class CliResult {
  /// e.g. ['mytool', 'db', 'migrate']
  final List<String> commandPath;
  final Map<String, bool> _flags;
  final Map<String, List<String>> _options;
  final Map<String, List<String>> _arguments;

  CliResult._(this.commandPath, this._flags, this._options, this._arguments);

  bool flag(String name) =>
      _flags[name] ?? (throw ArgumentError('No flag named "$name".'));

  String? option(String name) => _get(_options, name, 'option').lastOrNull;

  List<String> multiOption(String name) => _get(_options, name, 'option');

  String? argument(String name) =>
      _get(_arguments, name, 'argument').firstOrNull;

  List<String> arguments(String name) => _get(_arguments, name, 'argument');

  static List<String> _get(
    Map<String, List<String>> m,
    String name,
    String kind,
  ) => m[name] ?? (throw ArgumentError('No $kind named "$name".'));
}
