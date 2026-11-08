import 'package:cmdline/cmdline.dart';

/// Builds the coloured help screen for a command.
///
/// Give it the picked commands from the top down (like `[todo, add]`) and
/// call [build]. It returns the text instead of printing it, so it is easy to
/// test. [CLI.start] prints it for you on `--help`.
///
/// {@category cli}
class HelpPrinter {
  /// Colour of the program name in the title.
  static const AnsiColour _titleColour = AnsiColour(14);

  /// Colour of command, flag and option names.
  static const AnsiColour _nameColour = AnsiColour(10);

  /// Colour of section headings like "Usage".
  static const AnsiColour _headingColour = AnsiColour(11);

  /// Colour of error messages.
  static const AnsiColour _errorColour = AnsiColour(9);

  /// The picked commands from the top down. The last one gets the help.
  final List<Command> commands;

  /// Prepares the help screen for the last command in [commands].
  const HelpPrinter(this.commands);

  /// Builds the whole help screen as one string.
  String build() {
    final command = commands.last;
    final path = [for (final c in commands) c.name].join(' ');
    final lines = <String>[];
    // lines.add('\n');

    // Title, e.g. "todo add" or "todo 1.0.0".
    var title = path.bold.foreground(_titleColour);
    final root = commands.first;
    if (root is CLI && root.version != null && commands.length == 1) {
      title = '$title ${'v${root.version}'.dim}';
    }
    lines.add(title);
    if (command.help.isNotEmpty) lines.add(command.help.italic.dim);

    // Usage line, e.g. "todo add <key> [options]".
    final usage = StringBuffer(path);
    if (_visibleCommands(command).isNotEmpty) usage.write(' <command>');
    for (final argument in command.arguments) {
      usage.write(' ${_argumentLabel(argument)}');
    }
    usage.write(' [options]');
    lines.add('');
    lines.add(_heading('Usage'));
    lines.add('  $usage');

    // Sub-commands.
    final rows = <List<String>>[];
    for (final sub in _visibleCommands(command)) {
      var label = sub.name;
      if (sub.aliases.isNotEmpty) label += ', ${sub.aliases.join(', ')}';
      rows.add([label, sub.help]);
    }
    _addSection(lines, 'Commands', rows);

    // Plain words the command expects, like <key>.
    _addSection(lines, 'Arguments', [
      for (final argument in command.arguments)
        [_argumentLabel(argument), _argumentHelp(argument)],
    ]);

    // Flags and options from parent commands work here too, so they are
    // listed after this command's own, nearest parent first.
    _addSection(lines, 'Flags', [
      for (final c in commands.reversed) ..._flagRows(c),
      if (!_declaresVerbose()) _verboseRow(),
      ['-h, --help', 'Show this help'],
      if (root is CLI && root.version != null && commands.length == 1)
        ['    --version', 'Show the version'],
    ]);

    _addSection(lines, 'Options', [
      for (final c in commands.reversed) ..._optionRows(c),
    ]);

    if (_visibleCommands(command).isNotEmpty) {
      lines.add('');
      lines.add('Run "$path <command> --help" for more about a command.'.dim);
    }

    lines.add('');

    return lines.join('\n');
  }

  /// Builds the red error message and a hint about `--help`.
  static String error(CLIError error) {
    final path = error.commandPath.join(' ');

    return '${'Error:'.bold.foreground(_errorColour)} ${error.message}\n'
        '${'Run "$path --help" to see what is available.'.dim}';
  }

  /// One row per visible flag of [command], like `-u, --urgent`.
  List<List<String>> _flagRows(Command command) {
    final rows = <List<String>>[];

    for (final flag in command.flags) {
      if (flag.hidden) continue;
      final long = flag.negatable ? '--[no-]${flag.name}' : '--${flag.name}';
      final extra = flag.defaultValue ? ' ${'[on by default]'.dim}' : '';
      rows.add([_withShort(flag.short, long), '${flag.help}$extra']);
    }

    return rows;
  }

  /// One row per visible option of [command], like `-T, -text <text>`.
  List<List<String>> _optionRows(Command command) {
    final rows = <List<String>>[];

    for (final option in command.options) {
      if (option.hidden) continue;
      final long = '-${option.name} <${option.valueName ?? option.name}>';
      rows.add([_withShort(option.short, long), _optionHelp(option)]);
    }

    return rows;
  }

  /// Whether any picked command declares its own `verbose` flag.
  ///
  /// If so, it is already listed and the built-in row is left out.
  bool _declaresVerbose() {
    for (final command in commands) {
      if (command.findFlag(CLI.verboseFlag.name) != null) return true;
    }

    return false;
  }

  /// The help row for the built-in [CLI.verboseFlag].
  ///
  /// The `-v` short name is left out if something else already uses it.
  List<String> _verboseRow() {
    String? short = CLI.verboseFlag.short;
    for (final command in commands) {
      if (command.findFlagByShort('v') != null) short = null;
    }

    return [
      _withShort(short, '--${CLI.verboseFlag.name}'),
      CLI.verboseFlag.help,
    ];
  }

  /// The help text of [option], followed by its rules in dim text.
  String _optionHelp(Option option) {
    final notes = <String>[];
    if (option.required) notes.add('required');
    if (option.allowed.isNotEmpty) notes.add(option.allowed.join(' | '));
    if (option.defaultValue != null)
      notes.add('default: ${option.defaultValue}');
    if (option.multiple) notes.add('can repeat');

    if (notes.isEmpty) return option.help;

    return '${option.help} ${'[${notes.join(', ')}]'.dim}'.trim();
  }

  /// How [argument] is written: `<key>` when required, `[key]` when not.
  String _argumentLabel(Argument argument) =>
      argument.required ? '<${argument.name}>' : '[${argument.name}]';

  /// The help text of [argument], with "required" or "optional" in dim text.
  String _argumentHelp(Argument argument) {
    final note = argument.required ? '[required]' : '[optional]';

    return '${argument.help} ${note.dim}'.trim();
  }

  /// Puts the short name in front, like `-v, --verbose`, or lines it up.
  ///
  /// Without a short name, four spaces keep the long names in one column.
  String _withShort(String? short, String long) =>
      short == null ? '    $long' : '-$short, $long';

  /// The sub-commands of [command] that aren't hidden.
  List<Command> _visibleCommands(Command command) => [
    for (final sub in command.commands)
      if (!sub.hidden) sub,
  ];

  /// A section heading, like "Usage".
  String _heading(String text) => text.bold.foreground(_headingColour);

  /// Adds a heading and lined-up rows to [lines]. Skips empty sections.
  void _addSection(
    List<String> lines,
    String heading,
    List<List<String>> rows,
  ) {
    if (rows.isEmpty) return;

    // Find the longest label so the help texts line up in one column.
    var width = 0;
    for (final row in rows) {
      if (row[0].length > width) width = row[0].length;
    }

    lines.add('');
    lines.add(_heading(heading));
    for (final row in rows) {
      // Pad before colouring, because colour codes would throw off the width.
      final label = row[0].padRight(width).foreground(_nameColour);
      lines.add('  $label  ${row[1]}'.trimRight());
    }
  }
}
