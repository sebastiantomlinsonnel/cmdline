import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  final List<String> changes = await Prompts.tags('agewf');
  dev(changes);
}
