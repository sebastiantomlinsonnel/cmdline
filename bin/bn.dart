import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  final changes = await Prompts.password('AF');
  dev(changes);
}
