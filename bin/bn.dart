import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  final changes = await Prompts.search('AF', [
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
    'af',
  ]);
  dev(changes);
}
