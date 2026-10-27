part of '../../cli.dart';

class CliException implements Exception {
  final String message;

  const CliException(this.message);

  @override
  String toString() => message;
}
