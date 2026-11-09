// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:async';
import 'dart:math' as math;

import '../../../../cmdline.dart';

/// Work for [Tasks.run]: gets a [TaskContext] to report on itself.
typedef TaskWork = Future<void> Function(TaskContext task);

/// One piece of work in a task list.
///
/// {@category cli}
class Task {
  /// The name shown for the task.
  final String label;

  /// The work to do.
  final TaskWork work;

  /// Creates a task.
  const Task(this.label, this.work);
}

/// What a running task can tell the screen about itself.
///
/// {@category cli}
class TaskContext {
  final void Function() _changed;
  final void Function(String line) _log;

  /// The current status text, shown dim after the label.
  String status = '';

  /// How far along the task is, from 0 to 1, or null if unknown.
  double? fraction;

  TaskContext._(this._changed, this._log);

  /// Shows [text] after the task's label.
  void update(String text) {
    status = text;
    _changed();
  }

  /// Shows a small bar for [done] out of [total] (or a [done] fraction of 1).
  void progress(num done, [num total = 1]) {
    fraction = total <= 0 ? 1 : (done / total).clamp(0, 1).toDouble();
    _changed();
  }

  /// Prints [line] above the task list.
  void log(String line) => _log(line);
}

/// How a task went.
///
/// {@category cli}
class TaskReport {
  /// The task's label.
  final String label;

  /// What it threw, or null if it worked.
  final Object? error;

  /// How long it ran.
  final Duration elapsed;

  /// Creates a report.
  const TaskReport(this.label, this.error, this.elapsed);

  /// Whether the task worked.
  bool get ok => error == null;
}

enum _State { waiting, running, passed, failed }

/// Several tasks running side by side, each with a live status line.
///
/// {@category cli}
abstract final class Tasks {
  /// Runs [tasks], up to [concurrency] at a time, showing each one's state:
  /// waiting, spinning, ticked or crossed, with its status and progress.
  ///
  /// A task that throws is marked failed and the others carry on. Gives
  /// back a report for each task, in order. When output is piped, one line
  /// is printed per task as it ends.
  ///
  /// ```dart
  /// final reports = await Tasks.run([
  ///   Task('Download', (task) async {
  ///     for (var i = 1; i <= 10; i++) {
  ///       await fetchChunk(i);
  ///       task.progress(i, 10);
  ///     }
  ///   }),
  ///   Task('Build', (task) async {
  ///     task.update('compiling');
  ///     await build();
  ///   }),
  /// ]);
  /// if (reports.any((r) => !r.ok)) exitCode = 1;
  /// ```
  static Future<List<TaskReport>> run(
    List<Task> tasks, {
    int concurrency = 4,
    List<String> frames = kSPINNER_FRAMES,
  }) async {
    final terminal = Terminal.current;
    final live = terminal.supportsAnsi;
    final region = LiveRegion(terminal);
    final states = List.filled(tasks.length, _State.waiting);
    final clocks = [for (final _ in tasks) Stopwatch()];
    final errors = List<Object?>.filled(tasks.length, null);
    var frame = 0;
    late final List<TaskContext> contexts;

    void draw() {
      if (!live) return;
      region.draw([
        for (var i = 0; i < tasks.length; i++)
          _line(tasks[i].label, states[i], contexts[i], clocks[i].elapsed, frames[frame % frames.length])
              .fitWidth(terminal.columns - 1),
      ]);
    }

    void log(String line) {
      if (live) region.clear();
      PromptRunner.say(line, terminal);
      draw();
    }

    contexts = [for (final _ in tasks) TaskContext._(draw, log)];
    final timer = live
        ? Timer.periodic(const Duration(milliseconds: 80), (_) {
            frame++;
            draw();
          })
        : null;

    var next = 0;
    Future<void> worker() async {
      while (next < tasks.length) {
        final i = next++;
        states[i] = _State.running;
        clocks[i].start();
        draw();
        try {
          await tasks[i].work(contexts[i]);
          states[i] = _State.passed;
        } catch (error) {
          states[i] = _State.failed;
          errors[i] = error;
          contexts[i].status = '$error';
        }
        clocks[i].stop();
        if (live) {
          draw();
        } else {
          PromptRunner.say(_line(tasks[i].label, states[i], contexts[i], clocks[i].elapsed, ''), terminal);
        }
      }
    }

    try {
      await Future.wait([
        for (var w = 0; w < math.max(1, math.min(concurrency, tasks.length)); w++) worker(),
      ]);
    } finally {
      timer?.cancel();
      if (live) {
        region.finish([
          for (var i = 0; i < tasks.length; i++)
            _line(tasks[i].label, states[i], contexts[i], clocks[i].elapsed, ''),
        ]);
      }
    }

    return [
      for (var i = 0; i < tasks.length; i++) TaskReport(tasks[i].label, errors[i], clocks[i].elapsed),
    ];
  }

  static String _line(String label, _State state, TaskContext context, Duration elapsed, String frame) {
    final theme = AnsiTheme.current;
    final icon = switch (state) {
      _State.waiting => theme.glyphs.unchecked.foreground(theme.muted),
      _State.running => frame.foreground(theme.highlight),
      _State.passed => theme.tick.foreground(theme.success),
      _State.failed => theme.cross.foreground(theme.error),
    };
    final fraction = context.fraction;
    final bar = state == _State.running && fraction != null
        ? ' ${ProgressBar.bar(fraction, width: 12, colour: theme.highlight)} ${(fraction * 100).round()}%'
        : '';
    final status = context.status.isEmpty
        ? ''
        : ' ${context.status.foreground(state == _State.failed ? theme.error : theme.muted)}';
    final time = state == _State.waiting
        ? ''
        : ' ${'${(elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s'.foreground(theme.muted)}';
    final name = state == _State.waiting ? label.foreground(theme.muted) : label;

    return '$icon $name$bar$status$time';
  }
}
