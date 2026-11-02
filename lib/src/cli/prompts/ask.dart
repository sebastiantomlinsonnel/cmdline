import 'package:cmdline/cmdline.dart';

/// Asks the user a question and gives back what they type.
///
/// The question is drawn with [CliTheme.current]. A wrong answer shows an
/// error line and asks again.
///
/// * [defaultValue]: used when the user just presses Enter. Shown dim after
///   the question.
/// * [hidden]: don't show what is typed, for passwords.
/// * [required]: an empty answer isn't allowed (unless there's a default).
/// * [validator]: gives back a problem to show, or null if the answer is ok.
///
/// ```dart
/// final name = ask('Project name', defaultValue: 'my_app');
/// final port = ask('Port', validator: (a) =>
///     int.tryParse(a) == null ? 'Type a number' : null);
/// final secret = ask('Password', hidden: true);
/// ```
String ask(
  String prompt, {
  String? defaultValue,
  bool hidden = false,
  bool required = true,
  String? Function(String answer)? validator,
}) {
  return PromptLine.run<String>(
    prompt,
    hint: defaultValue == null || hidden ? '' : '($defaultValue)',
    hidden: hidden,
    shown: (answer) => hidden ? BULLET * answer.length : answer,
    check: (typed) {
      final answer = typed.isEmpty ? defaultValue ?? '' : typed;
      final problem = answer.isEmpty && required
          ? 'An answer is needed'
          : validator?.call(answer);

      return (value: answer, problem: problem);
    },
  );
}
