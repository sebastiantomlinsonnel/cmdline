import 'package:cmdline/cmdline.dart';

/// What [Parser] found in the user's arguments.
class ParseResult {
  /// The picked commands from the top down, like `[todo, add]`.
  ///
  /// The last one is the command to run.
  final List<Command> commands;

  /// The flags, options and leftover words, ready for `run`.
  final Input input;

  /// Whether the user asked for the help screen.
  final bool helpWanted;

  /// Whether the user asked for the version.
  final bool versionWanted;

  /// Creates a result. Normally only [Parser] does this.
  const ParseResult({
    required this.commands,
    required this.input,
    required this.helpWanted,
    required this.versionWanted,
  });

  /// The command the user picked, which is the one to run.
  Command get command => commands.last;
}

/// Reads the user's arguments one word at a time.
///
/// Make a new [Parser] for each list of arguments and call [parse]. Most code
/// never uses this directly, because [Cli.start] does it for you.
///
/// It understands:
/// * `--name value`, `--name=value`, `-n value` and `-nvalue` for options
/// * `--flag`, `-f`, grouped `-abc`, and `--no-flag` for negatable flags
/// * command names (and aliases), which switch to that command
/// * `--`, after which every word goes into [Input.rest]
/// * `--help`, `-h`, `help <command>` and `--version`
class Parser {
  /// The program whose commands, flags and options are understood.
  final Cli cli;

  /// The words the user typed.
  final List<String> arguments;

  /// The picked commands from the top down. Starts with just [cli].
  final List<Command> _commands = [];

  final Map<String, bool> _flags = {};
  final Map<String, List<String>> _options = {};
  final Set<String> _given = {};
  final List<String> _rest = [];
  bool _helpWanted = false;
  bool _versionWanted = false;

  /// Position of the next word to read in [arguments].
  int _next = 0;

  /// Prepares to read [arguments] for [cli].
  Parser(this.cli, this.arguments) {
    _commands.add(cli);
  }

  /// Reads every argument and returns what was found.
  ///
  /// Throws a [CliError] when the user made a mistake.
  ParseResult parse() {
    while (_next < arguments.length) {
      final word = arguments[_next];
      _next++;

      if (word == '--') {
        _rest.addAll(arguments.sublist(_next));
        break;
      } else if (word.startsWith('--')) {
        _readLong(word.substring(2));
      } else if (word.startsWith('-') && word.length > 1) {
        _readShort(word.substring(1));
      } else {
        _readWord(word);
      }
    }

    _fillDefaults();

    return ParseResult(
      commands: List.unmodifiable(_commands),
      input: Input(
        flags: _flags,
        options: _options,
        given: _given,
        rest: List.unmodifiable(_rest),
        commandPath: [for (final command in _commands) command.name],
      ),
      helpWanted: _helpWanted,
      versionWanted: _versionWanted,
    );
  }

  /// Reads a word that started with `--`, like `--name=Sam` or `--verbose`.
  void _readLong(String text) {
    var name = text;
    String? value;

    final equals = text.indexOf('=');
    if (equals != -1) {
      name = text.substring(0, equals);
      value = text.substring(equals + 1);
    }

    final option = _findOption(name);
    if (option != null) {
      _addOptionValue(option, value ?? _takeValue('--$name'));

      return;
    }

    final flag = _findFlag(name);
    if (flag != null) {
      if (value != null) _fail('The flag --$name does not take a value.');
      _setFlag(flag, true);

      return;
    }

    if (name.startsWith('no-')) {
      final negated = _findFlag(name.substring(3));
      if (negated != null && negated.negatable) {
        _setFlag(negated, false);

        return;
      }
    }

    if (name == 'help') {
      _helpWanted = true;
    } else if (name == 'version' && cli.version != null) {
      _versionWanted = true;
    } else {
      _fail('Unknown option --$name.');
    }
  }

  /// Reads a word that started with a single `-`, like `-v` or `-abc`.
  ///
  /// Each letter is a flag, until one is an option: the rest of the word (or
  /// the next word) is then that option's value.
  void _readShort(String letters) {
    for (var i = 0; i < letters.length; i++) {
      final letter = letters[i];

      final option = _findOptionByShort(letter);
      if (option != null) {
        final attached = letters.substring(i + 1);
        _addOptionValue(
          option,
          attached.isNotEmpty ? attached : _takeValue('-$letter'),
        );

        return;
      }

      final flag = _findFlagByShort(letter);
      if (flag != null) {
        _setFlag(flag, true);
      } else if (letter == 'h') {
        _helpWanted = true;
      } else {
        _fail('Unknown option -$letter.');
      }
    }
  }

  /// Reads a plain word: a command name, `help`, or a leftover word.
  void _readWord(String word) {
    final current = _commands.last;

    // Commands only count before any leftover words.
    if (_rest.isEmpty) {
      final sub = current.findCommand(word);
      if (sub != null) {
        _commands.add(sub);

        return;
      }

      if (current.commands.isNotEmpty) {
        if (word == 'help') {
          _helpWanted = true;

          return;
        }
        if (current.run == null) {
          _fail('Unknown command "$word".');
        }
      }
    }

    _rest.add(word);
  }

  /// Takes the next word as the value for [label], or fails if there is none.
  String _takeValue(String label) {
    if (_next >= arguments.length) {
      _fail('The option $label needs a value.');
    }
    final value = arguments[_next];
    _next++;

    return value;
  }

  /// Stores [value] for [option], after checking it is allowed.
  void _addOptionValue(Option option, String value) {
    if (option.allowed.isNotEmpty && !option.allowed.contains(value)) {
      _fail(
        '"$value" is not allowed for --${option.name}. '
        'Pick one of: ${option.allowed.join(', ')}.',
      );
    }

    if (option.multiple && _given.contains(option.name)) {
      _options[option.name]!.add(value);
    } else {
      _options[option.name] = [value];
    }
    _given.add(option.name);
  }

  /// Turns [flag] on or off.
  void _setFlag(Flag flag, bool value) {
    _flags[flag.name] = value;
    _given.add(flag.name);
  }

  /// Fills in defaults and checks required options for every picked command.
  ///
  /// Required options aren't checked when help or the version was asked for,
  /// so `todo add --help` still works.
  void _fillDefaults() {
    final checkRequired = !_helpWanted && !_versionWanted;

    for (final command in _commands) {
      for (final flag in command.flags) {
        _flags.putIfAbsent(flag.name, () => flag.defaultValue);
      }

      for (final option in command.options) {
        if (_options.containsKey(option.name)) continue;

        if (option.required && checkRequired) {
          _fail('Missing the required option --${option.name}.');
        }

        final defaultValue = option.defaultValue;
        _options[option.name] = defaultValue == null ? [] : [defaultValue];
      }
    }
  }

  /// Looks for an option called [name], from the picked command upwards.
  Option? _findOption(String name) {
    for (final command in _commands.reversed) {
      final option = command.findOption(name);
      if (option != null) return option;
    }

    return null;
  }

  /// Looks for an option with the short name [letter], from the picked
  /// command upwards.
  Option? _findOptionByShort(String letter) {
    for (final command in _commands.reversed) {
      final option = command.findOptionByShort(letter);
      if (option != null) return option;
    }

    return null;
  }

  /// Looks for a flag called [name], from the picked command upwards.
  Flag? _findFlag(String name) {
    for (final command in _commands.reversed) {
      final flag = command.findFlag(name);
      if (flag != null) return flag;
    }

    return null;
  }

  /// Looks for a flag with the short name [letter], from the picked command
  /// upwards.
  Flag? _findFlagByShort(String letter) {
    for (final command in _commands.reversed) {
      final flag = command.findFlagByShort(letter);
      if (flag != null) return flag;
    }

    return null;
  }

  /// Stops parsing with a [CliError] for the user.
  Never _fail(String message) {
    throw CliError(message, [for (final command in _commands) command.name]);
  }
}
