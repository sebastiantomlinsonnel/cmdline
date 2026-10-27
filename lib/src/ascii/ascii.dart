import 'package:cmdline/ascii.dart';
import 'package:cmdline/src/cmdline/cmdline.dart';

part 'constants/colours.dart';
part 'constants/controls.dart';
part 'constants/styling.dart';

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
  for (String token in data) {
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
  for (List<String> style in data) {
    temp.add('${style.join()}$RESET');
  }
  temp.add(RESET + NEWLINE);

  return temp.join();
}
