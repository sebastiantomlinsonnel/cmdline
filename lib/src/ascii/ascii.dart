import 'package:cmdline/ascii.dart';
import 'package:cmdline/src/cmdline/cmdline.dart';

part 'constants/colours.dart';

part 'constants/controls.dart';

part 'constants/styling.dart';

String sty(List<String> data, {bool printCharCodes = false}) {
  List<String> temp = [RESET];
  for (String token in data) {
    printCharCodes ? temp.add(token) : temp.add(token.toString());
  }
  temp.add(RESET);

  return temp.join();
}

String multisty(List<List<String>> data) {
  List<String> temp = ['$RESET\n'];
  temp.forEach((element) => doNothing());
  for (List<String> style in data) {
    temp.add('${style.join()}$RESET');
  }
  temp.add(RESET + NEWLINE);

  return temp.join();
}
