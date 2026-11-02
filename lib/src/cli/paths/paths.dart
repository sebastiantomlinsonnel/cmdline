import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

/// Joins up to four path parts with this system's separator.
///
/// Empty parts are skipped, and an absolute part starts the path over, so
/// `join('a', '/b')` gives `/b`. Use [joinAll] for more parts.
///
/// ```dart
/// join(homeDirectory, '.config', 'app.json'); // C:\Users\me\.config\app.json
/// ```
String join(String first, [String? second, String? third, String? fourth]) =>
    joinAll([first, ?second, ?third, ?fourth]);

/// Joins any number of path parts with this system's separator.
///
/// Works like [join], for when the parts are already in a list.
String joinAll(Iterable<String> parts) {
  var result = '';
  for (final part in parts) {
    if (part.isEmpty) continue;
    if (_rootLength(part) > 0 || result.isEmpty) {
      result = part;
    } else if (_isSeparator(result[result.length - 1])) {
      result += part;
    } else {
      result += '${Platform.pathSeparator}$part';
    }
  }

  return result;
}

/// Cleans up [path]: removes `.`, works out `..` and doubled separators.
///
/// On Windows, `/` is turned into `\`. An empty path gives `.`.
///
/// ```dart
/// normalize('a/./b/../c'); // a\c on Windows, a/c elsewhere
/// ```
String normalize(String path) {
  if (path.isEmpty) return '.';

  final separator = Platform.pathSeparator;
  final cleaned = Platform.isWindows ? path.replaceAll('/', r'\') : path;
  final rootLength = _rootLength(cleaned);
  final root = cleaned.substring(0, rootLength);

  final parts = <String>[];
  for (final part in cleaned.substring(rootLength).split(separator)) {
    if (part.isEmpty || part == '.') continue;
    if (part != '..') {
      parts.add(part);
    } else if (parts.isNotEmpty && parts.last != '..') {
      parts.removeLast();
    } else if (root.isEmpty) {
      // Only a relative path can climb above where it starts.
      parts.add('..');
    }
  }

  final body = parts.join(separator);
  if (root.isEmpty) return body.isEmpty ? '.' : body;
  // A UNC root like \\server\share needs a separator before the rest.
  final needsSeparator =
      body.isNotEmpty &&
      !_isSeparator(root[root.length - 1]) &&
      !_isDrive(root);

  return needsSeparator ? '$root$separator$body' : '$root$body';
}

/// Whether [path] starts from the top of a drive or the file system.
///
/// `C:\x`, `\\server\share` and `/x` are absolute; `x`, `.\x` and `C:x`
/// are not.
bool isAbsolute(String path) {
  final rootLength = _rootLength(path);
  if (rootLength == 0) return false;
  if (!Platform.isWindows) return true;

  // "\x" on its own is relative to the current drive.
  return path.startsWith(r'\\') ||
      path.startsWith('//') ||
      (rootLength == 3 && _isDrive(path.substring(0, 2)));
}

/// [path] as a full, cleaned-up path, starting from [pwd] if it is relative.
String absolute(String path) {
  if (isAbsolute(path)) return normalize(path);

  return normalize(File(path.isEmpty ? '.' : path).absolute.path);
}

/// The last part of [path], like `app.json` from `config/app.json`.
///
/// Trailing separators are ignored, so `a/b/` gives `b`.
String basename(String path) {
  final trimmed = _trimEnd(path);
  final rootLength = _rootLength(trimmed);
  if (trimmed.length == rootLength) return trimmed;

  return trimmed.substring(math.max(_lastSeparator(trimmed) + 1, rootLength));
}

/// The last part of [path] without its ending, like `app` from `app.json`.
String basenameWithoutExtension(String path) {
  final name = basename(path);
  final ending = fileExtension(name);

  return name.substring(0, name.length - ending.length);
}

/// The ending of [path]'s last part, dot included, like `.json`.
///
/// Gives an empty string when there is none. A name that only starts with a
/// dot, like `.bashrc`, has no ending.
String fileExtension(String path) {
  final name = basename(path);
  final dot = name.lastIndexOf('.');

  return dot <= 0 ? '' : name.substring(dot);
}

/// Everything in [path] before its last part, like `config` from
/// `config/app.json`.
///
/// Gives `.` when [path] has only one part.
String dirname(String path) {
  final trimmed = _trimEnd(path);
  final rootLength = _rootLength(trimmed);
  if (trimmed.length == rootLength) return trimmed.isEmpty ? '.' : trimmed;

  final last = _lastSeparator(trimmed);
  if (last < rootLength) {
    return rootLength == 0 ? '.' : trimmed.substring(0, rootLength);
  }

  return _trimEnd(trimmed.substring(0, last));
}

/// The user's home folder, like `C:\Users\me` or `/home/me`.
String get homeDirectory {
  final env = Platform.environment;
  final home = Platform.isWindows ? env['USERPROFILE'] : env['HOME'];

  return home ?? Directory.current.path;
}

/// The folder your app is working in.
///
/// Setting it also moves [TerminalCommand.directory], so commands run there
/// too. The folder must exist.
String get pwd => Directory.current.path;

set pwd(String path) {
  Directory.current = path;
  TerminalCommand.directory = Directory.current.path;
}

/// Whether [char] separates folders on this system.
bool _isSeparator(String char) =>
    char == '/' || (Platform.isWindows && char == r'\');

/// Whether [text] is a bare drive like `C:`.
bool _isDrive(String text) =>
    Platform.isWindows &&
    text.length == 2 &&
    text[1] == ':' &&
    RegExp('[a-zA-Z]').hasMatch(text[0]);

/// Where the last separator in [path] is, or -1 if there is none.
int _lastSeparator(String path) {
  final slash = path.lastIndexOf('/');
  if (!Platform.isWindows) return slash;

  return math.max(slash, path.lastIndexOf(r'\'));
}

/// [path] without separators at the end, keeping the root itself.
String _trimEnd(String path) {
  final rootLength = _rootLength(path);
  var end = path.length;
  while (end > rootLength && _isSeparator(path[end - 1])) {
    end--;
  }

  return path.substring(0, end);
}

/// How long the root at the start of [path] is.
///
/// The root is `/`, `C:\`, `C:`, `\` or `\\server\share`. Gives 0 for a
/// relative path.
int _rootLength(String path) {
  if (path.isEmpty) return 0;
  if (!Platform.isWindows) return path.startsWith('/') ? 1 : 0;

  final twoSeparators =
      path.length >= 2 && _isSeparator(path[0]) && _isSeparator(path[1]);
  if (twoSeparators) {
    // A network path: \\server\share is the root.
    var at = 2;
    for (var parts = 0; parts < 2; parts++) {
      while (at < path.length && !_isSeparator(path[at])) {
        at++;
      }
      if (parts == 0 && at < path.length) at++;
    }

    return at;
  }
  if (path.length >= 2 && _isDrive(path.substring(0, 2))) {
    return path.length >= 3 && _isSeparator(path[2]) ? 3 : 2;
  }

  return _isSeparator(path[0]) ? 1 : 0;
}
