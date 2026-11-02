import 'package:cmdline/cmdline.dart';

/// Asks a yes or no question and gives back true for yes.
///
/// A dim `[Y/n]` hint shows which answer Enter picks when there is a
/// [defaultValue]; without one, the user must type y or n.
///
/// ```dart
/// if (confirm('Delete the build folder?', defaultValue: false)) {
///   deleteDir('build');
/// }
/// ```
bool confirm(String prompt, {bool? defaultValue}) {
  final hint = switch (defaultValue) {
    true => '[Y/n]',
    false => '[y/N]',
    null => '[y/n]',
  };

  return PromptLine.run<bool>(
    prompt,
    hint: hint,
    shown: (yes) => yes ? 'Yes' : 'No',
    check: (typed) {
      final answer = switch (typed.toLowerCase()) {
        'y' || 'yes' => true,
        'n' || 'no' => false,
        '' => defaultValue,
        _ => null,
      };

      return (
        value: answer,
        problem: answer == null ? 'Please type y or n' : null,
      );
    },
  );
}
