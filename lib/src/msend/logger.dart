import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

class Logger {
  Logger._();

  /// The single logger. Always available; it only writes to a file after
  /// [open] has been called.
  static final Logger instance = Logger._();

  void Function(String message, String asciiMessage)? onLog;
  bool debugMode = true;
  Set<String>? levels;

  /// The open log file, or null when logs aren't being saved.
  _LogFile? _out;

  bool get isOpen => _out != null;

  String? get path => _out?.file.path;

  String getString(dynamic message, Level level, {DateTime? time}) {
    bool isDev = level == Level.dev;
    String bgC = const AsciiColorRgb.hex(0x2A2A70).bg;
    return [
      isDev ? BOLD : '',
      Logger.getLevel(level, Logger.getTimestamp(time ?? DateTime.now())),
      isDev ? RESET_BOLD_AND_DIM : '',
      isDev ? BOLD : '',
      isDev ? bgC : '',
      '$message',
      isDev ? RESET_BG : '',
      isDev ? RESET_BOLD_AND_DIM : '',
    ].join();
  }

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

  static Future<void> flush() async => instance._out?.flush();

  /// Stops saving to the file. The instance stays usable (console only).
  static Future<void> close() async {
    final _LogFile? out = instance._out;
    instance._out = null;
    await out?.close();
  }

  void add(DateTime now, String level, String message) {
    final _LogFile? out = _out;
    if (out == null) return;

    final Set<String>? only = levels;
    if (only != null && !only.contains(level)) return;

    out.write(now, level, message);
  }

  static String strip(String s) {
    if (!s.contains('\x1B')) return s;
    final StringBuffer b = StringBuffer();
    _plain(b, s);
    return b.toString();
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

  static String getTimestamp(DateTime now) {
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
    ].join();
  }

  /// Width of the longest level name (TRACE / DEBUG), so every tag lines up.
  static const int _tagWidth = 5;

  static String getLevel(Level level, String timestamp) {
    final String name = level.name.toUpperCase().padRight(_tagWidth);
    // Pad before colouring: the colour codes would otherwise count as characters.
    final String tag = level == Level.dev
        ? '${Logger.getVerbosityColour(level, '⬤ $name ]').background(const AsciiColorRgb.hex(0x2A2A70))} '
        : Logger.getVerbosityColour(level, '[ $name ] ');
    return '$tag$timestamp${Logger.getVerbosityColour(level, ' > ')}';
  }

  static String getVerbosityColour(Level level, String data) {
    switch (level) {
      case Level.trace:
        return data.foreground(const AsciiColourRgb.hex(0xFF77FF)).bold;
      case Level.debug:
        return data
            .foreground(const AsciiColour.rgb(3, 5, 4).opacity(0.8))
            .bold;
      case Level.fail:
        return data
            .foreground(const AsciiColour.rgb(5, 0, 0).opacity(0.9))
            .bold;
      case Level.pass:
        return data
            .foreground(const AsciiColour.rgb(1, 5, 1).opacity(0.8))
            .bold;
      case Level.warn:
        return data
            .foreground(const AsciiColour.rgb(5, 3, 0).opacity(0.9))
            .bold;
      case Level.log:
        return data
            .foreground(const AsciiColour.rgb(5, 5, 5).opacity(0.9))
            .bold;
      case Level.dev:
        return data.foreground(const AsciiColourRgb.hex(0xFF77FF));
    }
  }

  static final List<String> _d2 = List<String>.generate(
    100,
    (int i) => i < 10 ? '0$i' : '$i',
    growable: false,
  );

  static const Map<Level, String> _tags = <Level, String>{
    Level.trace: '[TRACE] ',
    Level.debug: '[DEBUG] ',
    Level.fail: '[FAIL ] ',
    Level.pass: '[PASS ] ',
    Level.warn: '[WARN ] ',
    Level.log: '[LOG  ] ',
  };

  static const List<String> _spinnerFrames = <String>[
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  ];
  static Timer? _spinnerTimer;
  static String? _spinnerLabel;

  static bool get isSpinning => _spinnerLabel != null;

  /// Shows an animated spinner on the current line until [stopSpinner].
  /// Starting a new one replaces any spinner already running.
  static void startSpinner(
    String label, {
    Level level = Level.log,
    Duration interval = const Duration(milliseconds: 300),
  }) {
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerLabel = label;
    // if (!stdout.hasTerminal) return; // piped output: skip the animation

    int frame = 0;
    void draw() {
      final String text = '${_spinnerFrames[frame]} $label';
      stdout.write('${CLEAR_LINE}${instance.getString(text, level)}');
      frame = (frame + 1) % _spinnerFrames.length;
    }

    draw();
    _spinnerTimer = Timer.periodic(interval, (Timer _) => draw());
  }

  /// Stops the spinner and prints [message] (or the spinner's label) at [level].
  static void stopSpinner([String? message, Level level = Level.pass]) {
    final String? label = _spinnerLabel;
    if (label == null) return;
    _spinnerTimer?.cancel();
    _spinnerTimer = null;
    _spinnerLabel = null;
    stdout.write(CLEAR_LINE);
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

  static void print(String message, Level verbosity) {
    final DateTime now = DateTime.now();
    final String ascii = Logger.instance.getString(
      message,
      verbosity,
      time: now,
    );
    stdout.writeln(ascii);
    final Logger log = Logger.instance;
    log.add(now, verbosity.name.toUpperCase(), message);
    final onLog = log.onLog;
    if (onLog == null) return;
    try {
      onLog(Logger.strip(ascii), ascii);
    } catch (e) {
      fail(e);
    }
  }

  Future<String> demo() async {
    Logger.startSpinner('Starting logger');
    await delay(0, seconds: 3);
    Logger.stopSpinner('Loading Complete!', Level.pass);
    return instance.getString('Built, not logged', Level.debug);
  }

  void demoLevels() {
    trace('This is a trace message');
    debug('This is a $BOLD debug message');
    fail('This type shows that something has FAILED');
    pass('This type shows that something has NOT failed');
    warn('This will show when you want to warn');
    dev('Dev messages only show in debug mode and aren\'t logged');
  }
}

enum Level { log, warn, pass, fail, debug, trace, dev }

/// Buffered, rotating writer for tFhe log file. Only exists while open.
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
    if (!append && await file.exists()) await file.delete();
    final int written = await file.exists() ? await file.length() : 0;

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
    buffer.write(Logger._tags[level] ?? '[$level] ');
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
    final List<String> d2 = Logger._d2;
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
      if (await previous.exists()) await previous.delete();
      await file.rename(previous.path);
    } catch (_) {}

    try {
      _sink = file.openWrite(mode: FileMode.writeOnlyAppend);
      unawaited(_sink.done.catchError((Object _) {}));
      _written = await file.exists() ? await file.length() : 0;
    } catch (_) {
      _written = 0;
    }

    _rotating = false;
    _drain();
  }
}

String getDev(dynamic message) =>
    Logger.instance.getString('$message', Level.dev);

String getTrace(dynamic message) =>
    Logger.instance.getString('$message', Level.trace);

String getDebug(dynamic message) =>
    Logger.instance.getString('$message', Level.debug);

String getFail(dynamic message) =>
    Logger.instance.getString('$message', Level.fail);

String getPass(dynamic message) =>
    Logger.instance.getString('$message', Level.pass);

String getWarn(dynamic message) =>
    Logger.instance.getString('$message', Level.warn);

String getLog(dynamic message) =>
    Logger.instance.getString('$message', Level.log);
