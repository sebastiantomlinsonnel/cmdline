import 'package:cmdline/ascii.dart';

class AsciiPrinter {
  final List<Object?> tokens;

  final String separator;

  const AsciiPrinter(this.tokens, {this.separator = ''});

  static String value(List<Object?> tokens, {String separator = ''}) =>
      '${tokens.join(separator)}$RESET';

  String output() {
    final string = toString();
    print(string);

    return string;
  }

  @override
  String toString() => value(tokens, separator: separator);
}
