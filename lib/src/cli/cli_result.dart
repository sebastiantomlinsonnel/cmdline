class CliResult {
  /// e.g. ['mytool', 'db', 'migrate']
  final List<String> commandPath;
  final Map<String, bool> _flags;
  final Map<String, List<String>> _options;
  final Map<String, List<String>> _arguments;

  CliResult(this.commandPath, this._flags, this._options, this._arguments);

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
