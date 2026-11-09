// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:async';

import '../../../../cmdline.dart';

/// An animated spinner with a label, for work of unknown length.
///
/// Start it, let the work run, then end it with [pass], [fail] or [stop].
/// It shows how long the work has taken. Use [log] to print lines above the
/// spinner while it runs. When output is piped, nothing animates and only
/// the final line is printed.
///
/// ```dart
/// final spinner = Spinner('Installing packages').start();
/// try {
///   await install();
///   spinner.pass('Installed 12 packages');
/// } catch (e) {
///   spinner.fail('Install failed: $e');
/// }
///
/// // Or let it handle the ending:
/// final data = await Spinner.run('Downloading', () => fetch(url));
/// ```
///
/// {@category cli}
class Spinner {
  /// The text after the spinner. Change it with [update].
  String label;

  /// The frames of the animation, like [kSPINNER_FRAMES] or [kSPINNER_LINE].
  final List<String> frames;

  /// How long each frame shows.
  final Duration interval;

  /// The colour of the spinner, or the theme's highlight when null.
  final AnsiInk? colour;

  final Terminal _terminal;
  late final LiveRegion _region = LiveRegion(_terminal);
  final Stopwatch _clock = Stopwatch();
  Timer? _timer;
  int _frame = 0;

  /// Creates a spinner. Nothing shows until [start].
  Spinner(
    this.label, {
    this.frames = kSPINNER_FRAMES,
    this.interval = const Duration(milliseconds: 80),
    this.colour,
    Terminal? terminal,
  }) : _terminal = terminal ?? Terminal.current;

  /// Runs [work] under a spinner, and ends it with a tick or a cross.
  ///
  /// [done] turns the result into the final message; the label is used when
  /// it is left out. An error ends with a cross and is thrown again.
  static Future<T> run<T>(
    String label,
    Future<T> Function() work, {
    String Function(T result)? done,
    List<String> frames = kSPINNER_FRAMES,
  }) async {
    final spinner = Spinner(label, frames: frames).start();
    try {
      final result = await work();
      spinner.pass(done?.call(result));

      return result;
    } catch (error) {
      spinner.fail('$label: $error');
      rethrow;
    }
  }

  /// Whether the spinner is showing.
  bool get isSpinning => _timer != null;

  /// How long the spinner has been running.
  Duration get elapsed => _clock.elapsed;

  bool get _live => _terminal.supportsAnsi;

  /// Starts the animation. Gives back the spinner, for chaining.
  Spinner start() {
    if (isSpinning) return this;
    _clock.start();
    _timer = Timer.periodic(interval, (_) => _draw());
    _draw();

    return this;
  }

  /// Changes the label while spinning.
  void update(String label) {
    this.label = label;
    _draw();
  }

  /// Prints [line] above the spinner, which keeps spinning below it.
  void log(String line) {
    if (_live) _region.clear();
    PromptRunner.say(line, _terminal);
    _draw();
  }

  /// Ends with a tick and [message] (or the label).
  void pass([String? message]) => _end(AnsiTheme.current.successLine(message ?? label));

  /// Ends with a cross and [message] (or the label).
  void fail([String? message]) => _end(AnsiTheme.current.errorLine(message ?? label));

  /// Ends with a warning sign and [message] (or the label).
  void warn([String? message]) {
    final theme = AnsiTheme.current;
    _end('$WARNING ${message ?? label}'.foreground(theme.warn));
  }

  /// Ends and removes the spinner, leaving nothing behind.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _clock.stop();
    if (_live) _region.clear();
  }

  void _end(String line) {
    final took = _took(elapsed);
    stop();
    PromptRunner.say('$line ${took.foreground(AnsiTheme.current.muted)}', _terminal);
  }

  void _draw() {
    if (!isSpinning || !_live) return;
    final theme = AnsiTheme.current;
    final frame = frames[_frame++ % frames.length];
    final line =
        '${frame.foreground(colour ?? theme.highlight)} $label '
        '${_took(elapsed).foreground(theme.muted)}';
    _region.draw([line.fitWidth(_terminal.columns - 1)]);
  }

  /// [time] as a short label, like `(1.2s)` or `(2m 5s)`.
  static String _took(Duration time) {
    final seconds = time.inMilliseconds / Duration.millisecondsPerSecond;
    if (seconds < Duration.secondsPerMinute) return '(${seconds.toStringAsFixed(1)}s)';

    return '(${time.inMinutes}m ${time.inSeconds % Duration.secondsPerMinute}s)';
  }
}
