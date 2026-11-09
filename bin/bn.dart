import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  await Prompts.ask('hi...');
  TextPrompt(
    'question',
    parser: (text) {
      return (problem: text, value: text);
    },
  );
}
