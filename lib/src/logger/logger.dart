library logger;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

part 'constants.dart';

/// The width of the longest verbosity tag
const int TAG_WIDTH = 10;

/// A complex yet intuitive logger
class Logger {
  /// Show the timestamp
  bool showTimestampInOutput = false;

  /// Run after every log
  void Function(String message)? onLog;

  /// The open log file, or null when logs aren't being saved.
  _LogFile? logFile;

  /// Checks if there is a log file open for [Logger] to print logs to
  bool get isOpen => logFile != null;

  /// Path of the log file if it exists
  String? get path => logFile?.file.path;

  /// Check if there is a currently active spinner
  bool get isSpinning => _spinnerLabel != null;

  Logger._();

  Timer? _spinnerTimer;
  String? _spinnerLabel;
  final Stopwatch _clock = Stopwatch()..start();
  int _lastLog = 0;

  /// Singleton pattern
  static final Logger instance = Logger._();

  /// Outputs a log message using [Logger]
  static void print(String message) {
    stdout.writeln(message);
    Logger.instance.._saveLog(message);
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
          tag.length > TAG_WIDTH ? tag.substring(0, TAG_WIDTH) : tag,
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
    final String fitted = name.length > TAG_WIDTH
        ? name.substring(0, TAG_WIDTH)
        : name;

    return getVerbosityColour(level, '${fitted.padRight(TAG_WIDTH)}|');
  }

  /// Start Logger with a log file
  Future<Logger> open(
    String path, {
    bool append = true,
    Duration flushInterval = const Duration(seconds: 2),
    int flushThreshold = 16 * 1024,
    int maxBytes = 5 * 1024 * 1024,
    Set<String>? levels,
    void Function(String message)? onLog,
    bool debugMode = true,
  }) async {
    await close();

    final Logger m = instance..onLog = onLog;

    m.logFile = await _LogFile.open(
      path,
      append: append,
      flushInterval: flushInterval,
      flushThreshold: flushThreshold,
      maxBytes: maxBytes,
    );

    return m;
  }

  /// Stops saving to the file. The instance stays usable (console only).
  Future<void> close() async {
    final _LogFile? out = instance.logFile;
    instance.logFile = null;
    await out?.close();
  }

  void _saveLog(String message) {
    final _LogFile? out = logFile;
    if (out == null) return;
    out.write(message);
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

  /// Shows an animated spinner on the current line until [stopSpinner].
  /// Starting a new one replaces any spinner already running.
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

  /// Stops the spinner and prints [message] (or the spinner's label) at [level].
  void stopSpinner([String? message, Level level = Level.pass]) {
    final String? label = _spinnerLabel;
    if (label == null) return;
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerLabel = null;
    stdout.write('$CLEAR_LINE$SHOW_CURSOR');
    _printAt(message ?? label, level);
  }

  /// Prints through the normal printers, so it also reaches the file and onLog.
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

/// Buffered, rotating writer for the log file. Only exists while open.
class _LogFile {
  final File file;
  IOSink _sink;
  int _written;
  final int flushThreshold;
  final int maxBytes;
  late final Timer _timer;
  final StringBuffer _buffer = StringBuffer();
  bool _rotating = false;

  _LogFile._(
    this.file,
    this._sink,
    this._written,
    Duration flushInterval,
    this.flushThreshold,
    this.maxBytes,
  ) {
    _timer = Timer.periodic(flushInterval, (Timer _) => _drain());
  }

  static Future<_LogFile> open(
    String path, {
    required bool append,
    required Duration flushInterval,
    required int flushThreshold,
    required int maxBytes,
  }) async {
    final File file = File(path);
    await file.parent.create(recursive: true);
    if (!append && await file.existsSync()) await file.delete();
    final int written = await file.existsSync() ? await file.length() : 0;

    // ignore: close_sinks
    final IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);
    unawaited(sink.done.catchError((Object _) {}));

    return _LogFile._(
      file,
      sink,
      written,
      flushInterval,
      flushThreshold,
      maxBytes,
    );
  }

  void write(String message, {bool force = false}) {
    _buffer.write(message);
    if (force || _buffer.length >= flushThreshold) _drain();
  }

  Future<void> flush() async {
    _drain();
    try {
      await _sink.flush();
    } catch (_) {}
  }

  Future<void> close() async {
    _timer.cancel();
    _drain();
    try {
      await _sink.flush();
      await _sink.close();
    } catch (_) {}
  }

  void _drain() {
    if (_rotating || _buffer.isEmpty) return;

    final String chunk = _buffer.toString();
    _buffer.clear();
    final List<int> bytes = utf8.encode(chunk);

    try {
      _sink.add(bytes);
    } catch (_) {
      return;
    }

    _written += bytes.length;
    if (maxBytes > 0 && _written >= maxBytes) unawaited(_rotate());
  }

  Future<void> _rotate() async {
    if (_rotating) return;
    _rotating = true;

    try {
      await _sink.flush();
      await _sink.close();
      final File previous = File('${file.path}.1');
      if (await previous.existsSync()) await previous.delete();
      await file.rename(previous.path);
    } catch (_) {}

    try {
      _sink = file.openWrite(mode: FileMode.writeOnlyAppend);
      unawaited(_sink.done.catchError((Object _) {}));
      _written = await file.existsSync() ? await file.length() : 0;
    } catch (_) {
      _written = 0;
    }

    _rotating = false;
    _drain();
  }
}
