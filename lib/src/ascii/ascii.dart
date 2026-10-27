import 'package:cmdline/ascii.dart';

String sty(List<String> data, {bool printCharCodes = false}) {
  List<String> temp = [reset];
  for (String token in data) {
    printCharCodes ? temp.add(token) : temp.add(token.toString());
  }
  temp.add(reset);

  return temp.join();
}

String multisty(List<List<String>> data, {bool printCharCodes = false}) {
  List<String> temp = ['$reset\n'];
  for (List<String> style in data) {
    temp.add('${style.join()}$reset');
  }
  temp.add(reset + newline);

  return temp.join();
}

//
// Putting a single channel back to the terminal's default, without disturbing
// the styles around it the way [reset] would.
//

/// Text back to the terminal's default colour — SGR 39.
const String RESET_FG = '${CSI}39$SGR';

/// Background back to the terminal's default — SGR 49.
const String RESET_BG = '${CSI}49$SGR';

/// Underline back to the text's own colour, underline still on — SGR 59.
const String RESET_UNDERLINE_COLOUR = '${CSI}59$SGR';
