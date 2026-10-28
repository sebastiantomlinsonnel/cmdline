import 'dart:convert';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// A program that is running in the background.
///
/// You get one from [Executable.start] or [Shell.start]. Your code keeps
/// going while the program runs, and you can talk to it or stop it.
///
/// ```dart
/// final server = await Executable('dart').start(['run', 'bin/server.dart']);
/// server.onLine = (line) => debug(line);
/// // ... later
/// await server.stop();
/// ```
class RunningProgram {
  /// Called with each line the program prints. Shows it with [log] by default.
  void Function(String line) onLine = log;

  /// Called with each error line the program prints. Shows it with [log] by
  /// default.
  void Function(String line) onErrorLine = log;

  final Process _process;
  final _output = StringBuffer();
  final _errors = StringBuffer();
  bool _running = true;
  bool _stopped = false;
  late final Future<void> _outputDone;
  late final Future<void> _errorsDone;

  /// Wraps a started [Process]. Normally only [Executable.start] does this.
  RunningProgram(this._process) {
    _outputDone = _readLines(_process.stdout, (line) {
      _output.writeln(line);
      onLine(line);
    });
    _errorsDone = _readLines(_process.stderr, (line) {
      _errors.writeln(line);
      onErrorLine(line);
    });
    _process.exitCode.then((_) => _running = false);
  }

  /// The program's process id, a number the system uses to tell programs apart.
  int get pid => _process.pid;

  /// Whether the program is still running.
  bool get isRunning => _running;

  /// Everything the program has printed normally so far.
  String get output => _output.toString();

  /// Everything the program has printed as errors so far.
  String get errors => _errors.toString();

  /// Sends [text] to the program, as if it was typed in.
  ///
  /// Add `\n` at the end to press Enter, like `write('yes\n')`.
  void write(String text) => _process.stdin.write(text);

  /// Tells the program there is nothing more to type in.
  ///
  /// Some programs, like `sort`, wait for this before they finish.
  Future<void> closeInput() async {
    try {
      await _process.stdin.close();
    } catch (_) {
      // The program had already finished, so there was nothing to close.
    }
  }

  /// Waits for the program to finish and gives back its exit code.
  Future<int> wait() async {
    final code = await _process.exitCode;

    // Wait for the last lines to come in, unless it was stopped on purpose.
    if (!_stopped) await Future.wait([_outputDone, _errorsDone]);

    return code;
  }

  /// Stops the program straight away and gives back its exit code.
  ///
  /// Any programs it started itself are stopped too.
  Future<int> stop() async {
    _stopped = true;
    if (Platform.isWindows) {
      // "taskkill /T" also stops the programs this one started.
      await Process.run('taskkill', ['/T', '/F', '/PID', '$pid']);
    } else {
      _process.kill();
    }

    return _process.exitCode;
  }

  /// Reads [stream] as text, calling [onLine] for each line.
  static Future<void> _readLines(
    Stream<List<int>> stream,
    void Function(String line) onLine,
  ) {
    return stream
        .transform(systemEncoding.decoder)
        .transform(const LineSplitter())
        .forEach(onLine);
  }
}
