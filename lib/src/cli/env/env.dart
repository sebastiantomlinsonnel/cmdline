import 'dart:collection';
import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Your app's own copy of the environment variables.
///
/// Starts as a copy of [Platform.environment]. Changes only affect your app
/// and the commands it runs with [TerminalCommand] (or `.run` on a string),
/// never the terminal that started it. On Windows, names ignore upper and
/// lower case, just like Windows does.
///
/// ```dart
/// env['APP_MODE'] = 'test';
/// env.prependToPath(join(pwd, 'tools'));
/// print(which('mytool'));
/// env['APP_MODE'] = null; // Removes it.
/// ```
final Env env = Env._();

/// The type of [env]. Use [env] instead of making your own.
class Env {
  final Map<String, String> _values = Platform.isWindows
      ? LinkedHashMap<String, String>(
          equals: (a, b) => a.toUpperCase() == b.toUpperCase(),
          hashCode: (key) => key.toUpperCase().hashCode,
        )
      : <String, String>{};

  Env._() {
    _values.addAll(Platform.environment);
  }

  /// Every variable, as a map you can read but not change.
  Map<String, String> get all => UnmodifiableMapView(_values);

  /// The folders in `PATH`, in the order they are searched.
  List<String> get path => (this['PATH'] ?? '')
      .split(_pathSeparator)
      .where((folder) => folder.isNotEmpty)
      .toList();

  set path(List<String> folders) => this['PATH'] = folders.join(_pathSeparator);

  /// `;` on Windows and `:` elsewhere.
  static String get _pathSeparator => Platform.isWindows ? ';' : ':';

  /// The value of the variable [name], or null if it isn't set.
  String? operator [](String name) => _values[name];

  /// Sets the variable [name]. Setting it to null removes it.
  void operator []=(String name, String? value) {
    if (value == null) {
      _values.remove(name);
    } else {
      _values[name] = value;
    }
  }

  /// Whether [folder] is one of the [path] folders.
  bool isOnPath(String folder) {
    final wanted = _comparable(folder);

    return path.any((entry) => _comparable(entry) == wanted);
  }

  /// Adds [folder] to the end of [path], so it is searched last.
  ///
  /// Does nothing if it is already there.
  void appendToPath(String folder) {
    if (!isOnPath(folder)) path = [...path, folder];
  }

  /// Adds [folder] to the start of [path], so it is searched first.
  ///
  /// Does nothing if it is already there.
  void prependToPath(String folder) {
    if (!isOnPath(folder)) path = [folder, ...path];
  }

  /// Removes [folder] from [path].
  void removeFromPath(String folder) {
    final unwanted = _comparable(folder);
    path = path.where((entry) => _comparable(entry) != unwanted).toList();
  }

  /// Puts every variable back the way it was when the app started.
  void reset() => _values
    ..clear()
    ..addAll(Platform.environment);

  /// Prints the variables as a table, optionally only names matching [only].
  ///
  /// [only] is a wildcard pattern like `JAVA*`. Long values are cut to fit
  /// the terminal.
  void printAll({String? only}) {
    final matcher = only == null ? null : globToRegExp(only);
    final names =
        _values.keys.where((name) => matcher?.hasMatch(name) ?? true).toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    if (names.isEmpty) return;

    final nameWidth = names
        .map((n) => n.length)
        .reduce((a, b) => a > b ? a : b);
    final columns = stdout.hasTerminal ? stdout.terminalColumns : 120;
    final valueWidth = columns - nameWidth - 7;

    String fit(String value) => value.length <= valueWidth || valueWidth < 2
        ? value
        : '${value.substring(0, valueWidth - 1)}$ELLIPSIS';

    CliTheme.say(
      table(
        [
          for (final name in names)
            [name.foreground(CliTheme.current.highlight), fit(_values[name]!)],
        ],
        header: ['Name', 'Value'],
      ),
    );
  }

  /// [folder] cleaned up for comparing, ignoring case on Windows.
  String _comparable(String folder) {
    final cleaned = normalize(folder);

    return Platform.isWindows ? cleaned.toLowerCase() : cleaned;
  }
}

/// The full path of the program [name] found on [Env.path], or null.
///
/// Uses [env], so folders you add to the path are searched too. On Windows,
/// a name without an ending also tries the endings in `PATHEXT` (like
/// `.exe` and `.bat`). A [name] with a folder in it is only checked as is.
///
/// ```dart
/// final git = which('git'); // C:\Program Files\Git\cmd\git.exe
/// if (git == null) warn('Git is not installed');
/// ```
String? which(String name) {
  final candidates = _withEndings(name);
  if (name.contains('/') || (Platform.isWindows && name.contains(r'\'))) {
    for (final candidate in candidates) {
      if (_isProgram(candidate)) return absolute(candidate);
    }

    return null;
  }

  for (final folder in env.path) {
    for (final candidate in candidates) {
      final full = join(folder, candidate);
      if (_isProgram(full)) return full;
    }
  }

  return null;
}

/// [name] plus the Windows program endings it could have.
List<String> _withEndings(String name) {
  if (!Platform.isWindows || fileExtension(name).isNotEmpty) return [name];

  final endings = (env['PATHEXT'] ?? '.COM;.EXE;.BAT;.CMD')
      .split(';')
      .where((ending) => ending.isNotEmpty);

  return [for (final ending in endings) '$name${ending.toLowerCase()}'];
}

/// Whether [path] is a file that can be run.
bool _isProgram(String path) {
  if (!isFile(path)) return false;
  if (Platform.isWindows) return true;

  // Any of the three "execute" permission bits.
  const executeBits = 0x49;

  return FileStat.statSync(path).mode & executeBits != 0;
}
