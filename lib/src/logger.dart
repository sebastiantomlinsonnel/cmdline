library logger;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

export 'logger/frames.dart';
export 'logger/level.dart';
export 'logger/progress_bar.dart';

/// A complex yet intuitive logger
class Logger {
  /// Singleton
  static final Logger instance = Logger._();
  Timer? _spinnerTimer;
  String? _spinnerLabel;

  /// Check if there is a currently active spinner
  bool get isSpinning => _spinnerLabel != null;

  /// Show the timestamp
  bool showTimestampInOutput = false;

  /// Run after every log
  void Function(String message, String asciiMessage)? onLog;

  /// Controls whether [dev] and [debug] logs are shown
  bool debugMode = true;

  ///
  Set<String>? levels;

  /// Whether dev and debug messages are shown in the terminal.
  ///
  /// On by default. [Cli.start] turns it off unless the user typed
  /// `--verbose`. Hidden messages still go to the log file and [onLog].
  bool verbose = true;

  Logger._();

  /// The position of the `|` in the output
  int TAG_WIDTH = 5;

  final List<String> _d2 = List<String>.generate(
    100,
    (int i) => i < 10 ? '0$i' : '$i',
    growable: false,
  );

  /// The open log file, or null when logs aren't being saved.
  _LogFile? _out;

  /// Checks if there is a log file open for [Logger] to print logs to
  bool get isOpen => _out != null;

  /// Path of the log file if it exists
  String? get path => _out?.file.path;

  /// Get a formatted string
  static String getString(dynamic message, Level level, {bool? showTimestamp}) {
    String timestamp = '';
    if (showTimestamp ?? Logger.instance.showTimestampInOutput)
      timestamp = '${_getTimestamp()} ';

    return [timestamp, Logger.getStamp(level), ' $message'].join();
  }

  /// Start Logger with a log file
  static Future<Logger> open(
    String path, {
    bool append = true,
    Duration flushInterval = const Duration(seconds: 2),
    int flushThreshold = 16 * 1024,
    int maxBytes = 5 * 1024 * 1024,
    Set<String>? levels,
    void Function(String message, String asciiMessage)? onLog,
    bool debugMode = true,
  }) async {
    await close();

    final Logger m = instance
      ..levels = levels
      ..onLog = onLog
      ..debugMode = debugMode;

    m._out = await _LogFile.open(
      path,
      append: append,
      flushInterval: flushInterval,
      flushThreshold: flushThreshold,
      maxBytes: maxBytes,
    );

    return m;
  }

  /// Save log file
  static Future<void> flush() async => instance._out?.flush();

  /// Stops saving to the file. The instance stays usable (console only).
  static Future<void> close() async {
    final _LogFile? out = instance._out;
    instance._out = null;
    await out?.close();
  }

  void _add(DateTime now, String level, String message) {
    final _LogFile? out = _out;
    if (out == null) return;

    final Set<String>? only = levels;
    if (only != null && !only.contains(level)) return;

    out.write(now, level, message);
  }

  static void _plain(StringBuffer b, String s) {
    if (!s.contains('\x1B')) {
      b.write(s);

      return;
    }

    final int n = s.length;
    int i = 0;
    int start = 0;
    while (i < n) {
      if (s.codeUnitAt(i) != 0x1B) {
        i++;
        continue;
      }
      if (i > start) b.write(s.substring(start, i));
      i++;
      if (i < n && s.codeUnitAt(i) == 0x5B) {
        i++;
        while (i < n) {
          final int c = s.codeUnitAt(i++);
          if (c >= 0x40 && c <= 0x7E) break;
        }
      }
      start = i;
    }
    if (start < n) b.write(s.substring(start));
  }

  static String _getTimestamp() {
    final DateTime now = DateTime.now();
    final String ms = now.millisecond.toString().padLeft(3, '0');

    return [
      now.hour
          .toString()
          .padLeft(2, '0')
          .foreground(const AsciiColour.grey(14))
          .bold,
      ':'.foreground(const AsciiColour.grey(14)),
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
      '.'.foreground(const AsciiColour.grey(14)),
      ms.foreground(const AsciiColour.grey(10)),
      ' ',
    ].join();
  }

  /// Width of the longest level name (TRACE / DEBUG), so every tag lines up.

  static String getStamp(Level level) {
    final String name = level.name.toUpperCase().padRight(instance.TAG_WIDTH);
    final String tag = Logger.instance.getVerbosityColour(level, '$name |');

    return '$tag';
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
        return '${AsciiPalette.silver.bg}${AsciiPalette.ink.fg}$data'.bold;
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
  static void _printAt(String m, Level level) {
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

  /// Outputs a log message using [Logger]
  static void print(String message, Level verbosity) {
    final DateTime now = DateTime.now();
    final String ascii = Logger.getString(message, verbosity);
    final Logger inst = Logger.instance;
    final bool isDetail = verbosity == Level.dev || verbosity == Level.debug;
    if (inst.verbose || !isDetail) stdout.writeln(ascii);
    inst._add(now, verbosity.name.toUpperCase(), message);
    final onLog = inst.onLog;
    if (onLog == null) return;
    try {
      onLog(message, ascii);
    } catch (e) {
      fail(e);
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
  String _day = '';
  int _dayKey = -1;

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

  void write(DateTime now, String level, String message, {bool force = false}) {
    final StringBuffer buffer = _buffer;
    _stamp(buffer, now);
    buffer.write('$level |');
    Logger._plain(buffer, message);
    buffer.write('\n');

    if (force || buffer.length >= flushThreshold) _drain();
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

  void _stamp(StringBuffer b, DateTime t) {
    final List<String> d2 = Logger.instance._d2;
    final int key = t.day | (t.month << 5) | (t.year << 9);
    if (key != _dayKey) {
      _dayKey = key;
      _day = '${t.year}-${d2[t.month]}-${d2[t.day]} ';
    }
    b
      ..write(_day)
      ..write(d2[t.hour])
      ..write(':')
      ..write(d2[t.minute])
      ..write(':')
      ..write(d2[t.second])
      ..write('.');

    final int ms = t.millisecond;
    if (ms < 10) {
      b.write('00');
    } else if (ms < 100) {
      b.write('0');
    }
    b.write(ms);
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
