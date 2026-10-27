class CLIException implements Exception {
  final String message;

  const CLIException(this.message);

  @override
  String toString() => message;
}
