/// Thrown when a prompt ends without an answer.
///
/// That happens when the user presses Ctrl+C or Esc, when input runs out, or
/// when an unattended prompt has no default. `CLI.start` catches it and sets
/// exit code 130; catch it yourself to carry on another way.
///
/// ```dart
/// try {
///   final name = Prompts.ask('Name');
/// } on PromptCancelled {
///   writeln('Maybe next time');
/// }
/// ```
///
/// {@category cli}
class PromptCancelled implements Exception {
  /// The question that was being asked.
  final String question;

  /// Why it ended, like `cancelled` or `input ended`.
  final String reason;

  /// Creates the exception.
  const PromptCancelled(this.question, [this.reason = 'cancelled']);

  @override
  String toString() => 'PromptCancelled: "$question" ($reason)';
}
