import 'package:cmdline/cmdline.dart';

/// Colour of the program name in the title.
const AsciiColour _titleColour = AsciiColour(14);

/// Colour of command, flag and option names.
const AsciiColour _nameColour = AsciiColour(10);

/// Colour of section headings like "Usage".
const AsciiColour _headingColour = AsciiColour(11);

/// Colour of error messages.
const AsciiColour _errorColour = AsciiColour(9);

/// Builds the coloured help screen for a command.
///
/// Give it the picked commands from the top down (like `[todo, add]`) and
/// call [build]. It returns the text instead of printing it, so it is easy to
/// test. [Cli.start] prints it for you on `--help`.
class HelpPrinter {
  /// The picked commands from the top down. The last one gets the help.
  final List<Command> commands;

  /// Prepares the help screen for the last command in [commands].
  const HelpPrinter(this.commands);

  /// Builds the whole help screen as one string.
  String build() {
    final command = commands.last;
    final path = [for (final c in commands) c.name].join(' ');
    final lines = <String>[];
    lines.add('\n');

    // Title, e.g. "todo add" or "todo 1.0.0".
    var title = path.bold.foreground(_titleColour);
    final root = commands.first;
    if (root is Cli && root.version != null && commands.length == 1) {
      title = '$title ${'v${root.version}'.dim}';
    }
    lines.add(title);
    if (command.about.isNotEmpty) lines.add(command.about.italic.dim);

    // Usage line.
    var usage = path;
    if (_visibleCommands(command).isNotEmpty) usage += ' <command>';
    usage += ' [options]';
    lines.add('');
    lines.add(_heading('Usage'));
    lines.add('  $usage');

    // Sub-commands.
    final rows = <List<String>>[];
    for (final sub in _visibleCommands(command)) {
      var label = sub.name;
      if (sub.aliases.isNotEmpty) label += ', ${sub.aliases.join(', ')}';
      rows.add([label, sub.about]);
    }
    _addSection(lines, 'Commands', rows);

    // This command's own flags and options, plus the built-in ones.
    _addSection(lines, 'Options', [
      ..._optionRows(command),
      if (!_declaresVerbose()) _verboseRow(),
      ['-h, --help', 'Show this help'],
      if (root is Cli && root.version != null && commands.length == 1)
        ['    --version', 'Show the version'],
    ]);

    // Flags and options from parent commands still work here.
    final globalRows = <List<String>>[];
    for (var i = 0; i < commands.length - 1; i++) {
      globalRows.addAll(_optionRows(commands[i]));
    }
    _addSection(lines, 'Global options', globalRows);

    if (_visibleCommands(command).isNotEmpty) {
      lines.add('');
      lines.add('Run "$path <command> --help" for more about a command.'.dim);
    }

    lines.add('\n');
    return lines.join('\n');
  }

  /// Builds the red error message and a hint about `--help`.
  static String error(CliError error) {
    final path = error.commandPath.join(' ');

    return '${'Error:'.bold.foreground(_errorColour)} ${error.message}\n'
        '${'Run "$path --help" to see what is available.'.dim}';
  }

  /// One row per visible flag and option of [command]: `[label, help]`.
  List<List<String>> _optionRows(Command command) {
    final rows = <List<String>>[];

    // Classic style uses "-x" for every short name. Split style uses "--"
    // for flags and "-" for options, short or long.
    final split = _dashes == DashStyle.split;
    final flagShortDash = split ? '--' : '-';
    final optionDash = split ? '-' : '--';

    for (final flag in command.flags) {
      if (flag.hidden) continue;
      final long = flag.negatable ? '--[no-]${flag.name}' : '--${flag.name}';
      final extra = flag.defaultValue ? ' ${'[on by default]'.dim}' : '';
      rows.add([
        _withShort(flagShortDash, flag.short, long),
        '${flag.help}$extra',
      ]);
    }

    for (final option in command.options) {
      if (option.hidden) continue;
      final value = '<${option.valueName ?? option.name}>';
      final long = '$optionDash${option.name} $value';
      rows.add([_withShort('-', option.short, long), _optionHelp(option)]);
    }

    return rows;
  }

  /// Whether any picked command declares its own `verbose` flag.
  ///
  /// If so, it is already listed and the built-in row is left out.
  bool _declaresVerbose() {
    for (final command in commands) {
      if (command.findFlag(Cli.verboseFlag.name) != null) return true;
    }

    return false;
  }

  /// The help row for the built-in [Cli.verboseFlag].
  ///
  /// The `-v` short name is left out if something else already uses it.
  List<String> _verboseRow() {
    final dash = _dashes == DashStyle.split ? '--' : '-';
    String? short = Cli.verboseFlag.short;
    for (final command in commands) {
      if (command.findFlagByShort('v') != null ||
          command.findOptionByShort('v') != null) {
        short = null;
      }
    }

    return [
      _withShort(dash, short, '--${Cli.verboseFlag.name}'),
      Cli.verboseFlag.help,
    ];
  }

  /// The dash style of the program, or classic if it isn't a [Cli].
  DashStyle get _dashes {
    final root = commands.first;

    return root is Cli ? root.dashes : DashStyle.classic;
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

  /// Puts the short name in front, like `-v, --verbose`, or lines it up.
  ///
  /// [dash] is what goes before the short name, `-` or `--`. Without a short
  /// name, spaces of the same width keep the long names in one column.
  String _withShort(String dash, String? short, String long) {
    if (short == null) return '${' ' * (dash.length + 3)}$long';

    return '$dash$short, $long';
  }

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
