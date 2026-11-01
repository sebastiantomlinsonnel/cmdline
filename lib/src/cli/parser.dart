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
/// never uses this directly, because [CLI.start] does it for you.
///
/// It understands:
/// * flags: `--urgent`, `-u` (one lowercase letter), and `--no-urgent` for
///   negatable flags
/// * options: `-text Buy`, `-text=Buy`, `-T Buy` (one capital letter)
/// * command names (and aliases), which switch to that command
/// * `--`, after which every word goes into [Input.rest]
/// * `--help`, `-h`, `help <command>` and `--version`
class Parser {
  /// The program whose commands, flags and options are understood.
  final CLI cli;

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
  /// Throws a [CLIError] when the user made a mistake.
  ParseResult parse() {
    while (_next < arguments.length) {
      final word = arguments[_next];
      _next++;

      if (word == '--') {
        _rest.addAll(arguments.sublist(_next));
        break;
      } else if (word.startsWith('--')) {
        _readLongFlag(word.substring(2));
      } else if (word.startsWith('-') && word.length > 1) {
        _readSingleDash(word.substring(1));
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
        commands: List.unmodifiable(_commands),
        rest: List.unmodifiable(_rest),
        commandPath: [for (final command in _commands) command.name],
      ),
      helpWanted: _helpWanted,
      versionWanted: _versionWanted,
    );
  }

  /// Reads a word that started with `--`. It is always a long flag.
  ///
  /// For example `--urgent`, `--no-urgent`, `--help` or `--version`.
  void _readLongFlag(String text) {
    final name = _nameBeforeEquals(text);

    final flag = _findFlag(name);
    if (flag != null) {
      if (name != text) _fail('The flag --$name does not take a value.');
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
    } else if (_findOption(name) != null) {
      _fail('"$name" is an option, so it uses one dash: -$name');
    } else {
      _fail('Unknown flag --$name.');
    }
  }

  /// Reads a word that started with one `-`.
  ///
  /// * one lowercase letter is a short flag, like `-u`
  /// * one capital letter is a short option, like `-T Buy`
  /// * anything longer is a long option, like `-text Buy` or `-text=Buy`
  void _readSingleDash(String text) {
    final name = _nameBeforeEquals(text);

    if (name.length == 1 && name == name.toLowerCase()) {
      _readShortFlag(name, text);

      return;
    }

    final option = name.length == 1
        ? _findOptionByShort(name)
        : _findOption(name);
    if (option != null) {
      final value = name == text
          ? _takeValue('-$name')
          : text.substring(name.length + 1);
      _addOptionValue(option, value);

      return;
    }

    // Friendly hints for the most likely mix-ups.
    final lower = name.toLowerCase();
    if (name.length == 1 && _findFlagByShort(lower) != null) {
      _fail('-$name is not an option. Flags use lowercase: -$lower');
    }
    if (_findFlag(name) != null) {
      _fail('"$name" is a flag, so it uses two dashes: --$name');
    }
    _fail('Unknown option -$name.');
  }

  /// Reads a short flag: one lowercase [letter], like `-u`.
  ///
  /// [text] is the whole word without the dash, to spot `-u=yes`.
  void _readShortFlag(String letter, String text) {
    final flag = _findFlagByShort(letter);
    if (flag != null) {
      if (letter != text) _fail('The flag -$letter does not take a value.');
      _setFlag(flag, true);

      return;
    }

    if (letter == 'h') {
      _helpWanted = true;

      return;
    }

    final upper = letter.toUpperCase();
    if (_findOptionByShort(upper) != null) {
      _fail('-$letter is not a flag. Options use capitals: -$upper');
    }
    _fail('Unknown flag -$letter.');
  }

  /// The part of [text] before the first `=`, or all of it if there is none.
  String _nameBeforeEquals(String text) {
    final equals = text.indexOf('=');

    return equals == -1 ? text : text.substring(0, equals);
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
        '"$value" is not allowed for -${option.name}. '
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
          _fail('Missing the required option -${option.name}.');
        }

        final defaultValue = option.defaultValue;
        _options[option.name] = defaultValue == null ? [] : [defaultValue];
      }
    }

    // The built-in verbose flag, in case no command declared its own.
    _flags.putIfAbsent(CLI.verboseFlag.name, () => false);
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
  ///
  /// Falls back to the built-in [CLI.verboseFlag].
  Flag? _findFlag(String name) {
    for (final command in _commands.reversed) {
      final flag = command.findFlag(name);
      if (flag != null) return flag;
    }

    return name == CLI.verboseFlag.name ? CLI.verboseFlag : null;
  }

  /// Looks for a flag with the short name [letter], from the picked command
  /// upwards.
  ///
  /// Falls back to the built-in [CLI.verboseFlag].
  Flag? _findFlagByShort(String letter) {
    for (final command in _commands.reversed) {
      final flag = command.findFlagByShort(letter);
      if (flag != null) return flag;
    }

    return letter == CLI.verboseFlag.short ? CLI.verboseFlag : null;
  }

  /// Stops parsing with a [CLIError] for the user.
  Never _fail(String message) {
    throw CLIError(message, [for (final command in _commands) command.name]);
  }
}
