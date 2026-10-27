/// On/off switch: `--verbose`, `-v`, `--no-verbose`.
class CLIFlag {
  final String name;
  final String description;
  final String? abbr;
  final bool defaultValue;
  final bool negatable;

  const CLIFlag(
    this.name,
    this.description, {
    this.abbr,
    this.defaultValue = false,
    this.negatable = true,
  });
}
