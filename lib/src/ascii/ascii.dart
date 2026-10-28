import 'package:cmdline/cmdline.dart';

/// A string with escape codes already in it, waiting to be printed.
///
/// Build the string from the code constants or an [AsciiInk], then call
/// [output], a `print` that closes the style behind itself.
///
/// ```dart
/// Ascii('${CYAN_FG}${BOLD}ready').output();
/// ```
class Ascii {
  /// The text and codes to print, exactly as given.
  ///
  /// [RESET] is not stored here; it is added when the string is produced by
  /// [toString] or [output].
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ascii(this.string);

  /// Prints [string] closed with [RESET], and hands back what it printed.
  ///
  /// The return is the same string the terminal got, so it can go into a log
  /// or a test as well.
  String output() {
    final line = toString();
    // ignore: avoid_print
    print(line);

    return line;
  }

  /// [string] with [RESET] appended, so the style stops at the end of it.
  ///
  /// This is what [output] prints, so `'$ascii'` in an interpolation gives the
  /// same safe, closed-off text.
  @override
  String toString() => '$string$RESET';
}

/// Joins style codes and text into one string, with a [RESET] on each side.
///
/// Each item in [data] can be a code (like [BOLD] or [RED_FG]) or plain text.
/// They are joined in order with nothing between them. The leading [RESET]
/// stops earlier styles from leaking in, and the trailing one stops this style
/// from leaking out.
///
/// [printCharCodes] currently has no effect: both branches add the token
/// unchanged.
///
/// ```dart
/// print(sty([BOLD, RED_FG, 'Error:', RESET, ' file not found']));
/// ```
String sty(List<String> data, {bool printCharCodes = false}) {
  List<String> temp = [RESET];
  for (final String token in data) {
    printCharCodes ? temp.add(token) : temp.add(token.toString());
  }
  temp.add(RESET);

  return temp.join();
}

/// Joins several styled segments, resetting the style after each one.
///
/// Each inner list in [data] is one segment: its codes and text are joined,
/// then [RESET] is added, so a segment's style never carries into the next.
/// The result starts with [RESET] and a line break, and ends with [RESET] and
/// [NEWLINE].
///
/// ```dart
/// print(multisty([
///   [GREEN_FG, 'ok '],
///   [YELLOW_FG, 'warn '],
///   [RED_FG, 'fail'],
/// ]));
/// ```
String multisty(List<List<String>> data) {
  List<String> temp = ['$RESET\n'];
  temp.forEach((element) => doNothing());
  for (final List<String> style in data) {
    temp.add('${style.join()}$RESET');
  }
  temp.add(RESET + NEWLINE);

  return temp.join();
}
