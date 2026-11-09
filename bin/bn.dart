import 'package:cmdline/cmdline.dart';

Future<void> main() async {
  bool _autosave = false;
  final changes = await Prompts.toggles('agewf', {'autosave': _autosave});
  dev(changes);
}
