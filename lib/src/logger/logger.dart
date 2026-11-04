library logger;

import 'dart:async';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

part 'constants.dart';

/// The width of the longest verbosity tag

/// A complex yet intuitive logger
class Logger {
  /// Show the timestamp
  bool showTimestampInOutput = false;

  /// Run after every log
  void Function(String message)? onLog;

  /// The open log file, or null when logs aren't being saved.
  RandomAccessFile? logFile;

  /// Checks if there is a log file open for [Logger] to print logs to
  bool get isOpen => logFile != null;

  /// Path of the log file if it exists
  String? get path => logFile?.path;

  /// Check if there is a currently active spinner
  bool get isSpinning => _spinnerLabel != null;

  Logger._();

  Timer? _spinnerTimer;
  String? _spinnerLabel;
  final Stopwatch _clock = Stopwatch()..start();
  int _lastLog = 0;

  /// Singleton pattern
  static final Logger instance = Logger._();

  /// Start Logger with a log file
  Future<Logger> open(
    String path, {
    bool append = true,
    void Function(String)? onLog,
  }) async {
    close(); // don't leak an earlier file
    final File file = File(path);
    file.parent.createSync(recursive: true); // in case logs/ doesn't exist
    logFile = file.openSync(
      mode: append ? FileMode.writeOnlyAppend : FileMode.writeOnly,
    );
    this.onLog = onLog;

    return this;
  }

  /// Stops saving to the file. The instance stays usable (console only).
  void close() {
    logFile?.closeSync();
    logFile = null;
  }

  /// Writes a log to the logfile
  void write(String message) => logFile?.writeStringSync(message);

  /// Outputs a log message using [Logger]
  static void print(String message) {
    stdout.writeln(message);
    Logger.instance..write(message);
    try {
      Logger.instance.onLog?.call(message);
    } catch (e) {
      fail(e);
    }
  }

  /// Get the log for printing
  static String getString(
    dynamic message,
    Level level, {
    bool? showTimestamp,
    String? tag,
  }) {
    final StringBuffer _message = StringBuffer();
    if (showTimestamp ?? Logger.instance.showTimestampInOutput) {
      _message.writeAll([instance._getTimestamp()]);
    }
    if (tag == null) {
      _message.write(Logger.instance.getStamp(level));
    } else {
      _message.write(
        Logger.instance.getStamp(
          level,
          tag.length > _TAG_WIDTH ? tag.substring(0, _TAG_WIDTH) : tag,
        ),
      );
    }
    _message.write(' $message');
    return _message.toString();
  }

  /// Time since the last log, 5 characters wide
  String _sinceLast() {
    final int now = _clock.elapsedMicroseconds;
    final int us = now - _lastLog;
    _lastLog = now;

    if (us < 1000) return '${_threeDigits[us]}μs';
    if (us < 1000000) return '${_threeDigits[us ~/ 1000]}ms';
    if (us < 10000000) {
      final int cs = us ~/ 10000; // hundredths of a second, 100–999
      return '${cs ~/ 100}.${_twoDigits[cs % 100]}s';
    }
    if (us < 100000000) {
      final int ds = us ~/ 100000; // tenths of a second, 100–999
      return '${ds ~/ 10}.${ds % 10}s';
    }
    final int s = us ~/ 1000000;

    return s > 999 ? '>999s' : '${s}s'.padLeft(5);
  }

  String _getTimestamp() {
    final DateTime now = DateTime.now();
    final StringBuffer buf = StringBuffer();
    buf.writeAll([
      '['.foreground(const AsciiColour.grey(10)),
      now.minute
          .toString()
          .padLeft(2, '0')
          .foreground(const AsciiColour.grey(14))
          .bold,
      ':'.foreground(const AsciiColour.grey(14)),
      now.second
          .toString()
          .padLeft(2, '0')
          .foreground(const AsciiColour.grey(14))
          .bold,
      '+'.foreground(const AsciiColour.grey(14)),
      '${_sinceLast()}] '.foreground(const AsciiColour.grey(10)),
    ]);

    return buf.toString();
  }

  /// Width of the longest level name (TRACE / DEBUG), so every tag lines up.
  String getStamp(Level level, [String? tag]) {
    final String name = tag?.toUpperCase() ?? level.name.toUpperCase();
    final String fitted = name.length > _TAG_WIDTH
        ? name.substring(0, _TAG_WIDTH)
        : name;

    return getVerbosityColour(level, '${fitted.padRight(_TAG_WIDTH)}|');
  }

  /// Get the styling for a log message
  String getVerbosityColour(Level level, String data) {
    switch (level) {
      case Level.trace:
        return data.foreground(AsciiPalette.orchid).bold;
      case Level.debug:
        return data.foreground(AsciiPalette.mint).bold;
      case Level.fail:
        return data.foreground(AsciiPalette.brick).bold;
      case Level.pass:
        return data.foreground(AsciiPalette.leaf).bold;
      case Level.warn:
        return data.foreground(AsciiPalette.amber).bold;
      case Level.log:
        return data.foreground(AsciiPalette.snow).bold;
      case Level.dev:
        return data.foreground(AsciiPalette.rose).bold;
    }
  }

  /// Shows an animated spinner on the current line until [stopSpinner]
  void startSpinner(
    String label, {
    Level level = Level.log,
    Duration interval = const Duration(milliseconds: 300),
  }) {
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerLabel = '\rlabel';
    stdout.write(HIDE_CURSOR);

    int frame = 0;
    void draw() {
      final String text = '${kSPINNER_FRAMES[frame]} $label';
      stdout.write('${CLEAR_LINE}${getString(text, level)}');
      frame = (frame + 1) % kSPINNER_FRAMES.length;
    }

    draw();
    _spinnerTimer = Timer.periodic(interval, (Timer _) => draw());
  }

  /// Stops the spinner and prints [message] (or the spinner's label) at [level]
  void stopSpinner([String? message, Level level = Level.pass]) {
    final String? label = _spinnerLabel;
    if (label == null) return;
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerLabel = null;
    stdout.write('$CLEAR_LINE$SHOW_CURSOR');
    _printAt(message ?? label, level);
  }

  /// Prints through the normal printers, so it also reaches the file and onLog
  void _printAt(String m, Level level) {
    switch (level) {
      case Level.pass:
        pass(m);
      case Level.fail:
        fail(m);
      case Level.warn:
        warn(m);
      case Level.debug:
        debug(m);
      case Level.trace:
        trace(m);
      case Level.log || Level.dev:
        log(m);
    }
  }
}
