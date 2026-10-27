
/// Positional argument. Only the last one may be [variadic].
class CLIArgument {
  final String name;
  final String description;
  final bool required;
  final bool variadic;

  const CLIArgument(
    this.name,
    this.description, {
    this.required = true,
    this.variadic = false,
  });
}
