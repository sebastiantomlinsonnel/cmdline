import 'package:cmdline/cmdline.dart';

/// Parses command line arguments against a built [CLI].
///
/// Get one from [CLI.build]. After [parse], the parsed values are available
/// through [flags], [options] and [arguments]. Each call to [parse] starts
/// fresh, so a runner can be reused for many argument lists.
class CLIRunner {
  /// The top level command made from the [CLI].
  final CLICommand root;

  late CLICommand _command;
  final _flags = <String, CLIFlag>{};
  final _options = <String, CLIOption>{};
  final _flagValues = <String, bool>{};
  final _optionValues = <String, List<String>>{};
  final _argumentValues = <String, List<String>>{};
  final _setByUser = <String>{};

  CLIRunner(this.root);

  /// Flag values from the last [parse], keyed by flag name.
  Map<String, bool> get flags => Map.unmodifiable(_flagValues);

  /// Option values from the last [parse], keyed by option name.
  ///
  /// Each list holds one value, or several for a [CLIOption.multiple] option.
  /// It is empty when the option was not given and has no default.
  Map<String, List<String>> get options => Map.unmodifiable(
    _optionValues.map((k, v) => MapEntry(k, List<String>.unmodifiable(v))),
  );

  /// Positional argument values from the last [parse], keyed by argument name.
  Map<String, List<String>> get arguments => Map.unmodifiable(_argumentValues);

  /// Parses [args] and returns the command they selected.
  ///
  /// Walks into sub commands by name or alias, then reads flags, options and
  /// positional arguments for that command. Flags and options from parent
  /// commands are still accepted. Throws [CLIException] on bad input.
  CLICommand parse(List<String> args) {
    _flags.clear();
    _options.clear();
    _flagValues.clear();
    _optionValues.clear();
    _argumentValues.clear();
    _setByUser.clear();
    _enter(root);

    final positionals = <String>[];
    var onlyPositional = false;
    var i = 0;

    String nextValue(String name) {
      if (i + 1 >= args.length) {
        throw CLIException('Option "$name" needs a value.');
      }
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
        final sub = positionals.isEmpty ? _command.findSubCommand(arg) : null;
        if (sub != null) {
          _enter(sub);
        } else {
          positionals.add(arg);
        }
      }
    }

    if (identical(_command.run, doNothing) &&
        _command.subCommands.isNotEmpty &&
        positionals.isNotEmpty) {
      throw CLIException('Unknown command "${positionals.first}".');
    }

    _bindArguments(positionals);
    return _command;
  }

  /// Moves into [c]. Flags and options from parent commands stay valid.
  void _enter(CLICommand c) {
    _command = c;
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

  /// Handles `--name`, `--no-name`, `--name=value` and `--name value`.
  void _long(String body, String Function(String) nextValue) {
    final eq = body.indexOf('=');
    final name = eq == -1 ? body : body.substring(0, eq);
    final inline = eq == -1 ? null : body.substring(eq + 1);

    final flag = _flags[name];
    if (flag != null) {
      if (inline != null) {
        throw CLIException('Flag "--$name" does not take a value.');
      }
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
    throw CLIException('Unknown option "--$name".');
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
      throw CLIException('Unknown option "-$c".');
    }
  }

  void _setOption(CLIOption option, String value) {
    final allowed = option.allowed;
    if (allowed != null && !allowed.contains(value)) {
      throw CLIException(
        '"$value" is not allowed for --${option.name}. Allowed: ${allowed.join(', ')}.',
      );
    }
    final values = _optionValues[option.name]!;
    // First user value replaces the default; single options keep only the last.
    if (_setByUser.add(option.name) || !option.multiple) values.clear();
    values.add(value);
  }

  void _bindArguments(List<String> positionals) {
    var i = 0;
    for (final a in _command.arguments) {
      final List<String> values;
      if (a.variadic) {
        values = List.unmodifiable(positionals.sublist(i));
        i = positionals.length;
      } else {
        values = List.unmodifiable([if (i < positionals.length) positionals[i++]]);
      }
      if (a.required && values.isEmpty) {
        throw CLIException('Missing argument <${a.name}>.');
      }
      _argumentValues[a.name] = values;
    }
    if (i < positionals.length) {
      throw CLIException('Unexpected argument "${positionals[i]}".');
    }
  }
}
