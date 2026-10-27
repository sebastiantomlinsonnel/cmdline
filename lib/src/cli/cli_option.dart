/// Takes a value: `--target=web`, `--target web`, `-t web`, `-tweb`.
class CLIOption {
  final String name;
  final String description;
  final String? abbr;
  final String? defaultValue;
  final List<String>? allowed;
  final bool multiple;
  final String valueName;

  const CLIOption(
    this.name,
    this.description, {
    this.abbr,
    this.defaultValue,
    this.allowed,
    this.multiple = false,
    this.valueName = 'value',
  });
}
