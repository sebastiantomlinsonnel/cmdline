/// Positional argument. Only the last one may be [variadic].
class CliArgument {
  final String name;
  final String description;
  final bool required;
  final bool variadic;

  const CliArgument(
    this.name,
    this.description, {
    this.required = true,
    this.variadic = false,
  });
}
