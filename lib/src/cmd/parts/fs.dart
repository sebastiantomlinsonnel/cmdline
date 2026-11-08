part of '../cmd.dart';

/// {@category cmd}
/// {@subCategory fileSystem}
class _FileSystem {
  const _FileSystem._();

  /// Whether anything (a file, folder or link) is at [path].
  bool exists(String path) =>
      FileSystemEntity.typeSync(path, followLinks: false) !=
      FileSystemEntityType.notFound;

  /// Whether [path] is a file.
  bool isFile(String path) => FileSystemEntity.isFileSync(path);

  /// Whether [path] is a folder.
  bool isDirectory(String path) => FileSystemEntity.isDirectorySync(path);

  /// Whether [path] is a link (shortcut) to another file or folder.
  bool isLink(String path) => FileSystemEntity.isLinkSync(path);

  /// Creates an empty file at [path], or updates its time if it is there.
  ///
  /// Missing parent folders are created too.
  void touch(String path) {
    final file = File(path);
    if (file.existsSync()) {
      file.setLastModifiedSync(DateTime.now());

      return;
    }
    file.createSync(recursive: true);
  }

  /// Copies the file at [from] to [to].
  ///
  /// If [to] is a folder, the file keeps its name inside it. Throws a
  /// [FileError] if [from] isn't a file or [to] is already there, unless
  /// [overwrite] is true.
  void copy(String from, String to, {bool overwrite = false}) {
    if (!isFile(from)) throw FileError('No file to copy', from);

    final target = isDirectory(to) ? CMD.fs.join(to, basename(from)) : to;
    if (!overwrite && exists(target)) {
      throw FileError('Already exists', target);
    }

    Directory(dirname(target)).createSync(recursive: true);
    File(from).copySync(target);
  }

  /// Moves (or renames) the file at [from] to [to].
  ///
  /// If [to] is a folder, the file keeps its name inside it. Moving to another
  /// drive copies the file and then deletes the old one. Throws a [FileError]
  /// if [to] is already there, unless [overwrite] is true.
  void move(String from, String to, {bool overwrite = false}) {
    if (!isFile(from)) throw FileError('No file to move', from);

    final target = isDirectory(to) ? join(to, basename(from)) : to;
    if (exists(target)) {
      if (!overwrite) throw FileError('Already exists', target);
      File(target).deleteSync();
    }

    Directory(dirname(target)).createSync(recursive: true);
    try {
      File(from).renameSync(target);
    } on FileSystemException {
      // Renaming can't cross drives, so copy and delete instead.
      File(from).copySync(target);
      File(from).deleteSync();
    }
  }

  /// Deletes the file at [path].
  ///
  /// Throws a [FileError] if it isn't a file.
  void deleteFile(String path) {
    if (!isFile(path)) throw FileError('No file to delete', path);
    File(path).deleteSync();
  }

  /// Tries to delete the file at [path].
  ///
  /// Returns if it isn't a file.
  void tryDeleteFile(String path) {
    if (!isFile(path)) return;
    File(path).deleteSync();
  }

  /// Creates the folder at [path], along with any missing parent folders.
  ///
  /// Does nothing if it is already there.
  void createDir(String path) => Directory(path).createSync(recursive: true);

  /// Deletes the folder at [path] and everything in it.
  ///
  /// Throws a [FileError] if it isn't a folder.
  void deleteDir(String path) {
    if (!isDirectory(path)) throw FileError('No folder to delete', path);
    Directory(path).deleteSync(recursive: true);
  }

  /// Tries to delete the folder at [path] and everything in it.
  ///
  /// Returns if it isn't a folder.
  void tryDeleteDir(String path) {
    if (!isDirectory(path)) return;
    Directory(path).deleteSync(recursive: true);
  }

  /// Copies everything in the folder [from] into the folder [to].
  ///
  /// [to] is created if it is missing. Files already in [to] cause a
  /// [FileError], unless [overwrite] is true. Give [filter] to copy only some
  /// files; it gets each file's path.
  void copyTree(
    String from,
    String to, {
    bool overwrite = false,
    bool Function(String path)? filter,
  }) {
    if (!isDirectory(from)) throw FileError('No folder to copy', from);
    final source = absolute(from);
    createDir(to);

    final entries = Directory(source)
        .listSync(recursive: true, followLinks: false);
    for (final entry in entries) {
      final target = join(to, entry.path.substring(source.length + 1));
      if (entry is Directory) {
        createDir(target);
      } else if (entry is File && (filter == null || filter(entry.path))) {
        copy(entry.path, target, overwrite: overwrite);
      }
    }
  }

  /// Moves everything in the folder [from] into the folder [to].
  ///
  /// Works like [copyTree], then deletes [from].
  void moveTree(String from, String to, {bool overwrite = false}) {
    copyTree(from, to, overwrite: overwrite);
    deleteDir(from);
  }

  /// Replaces [existing] with [replacement] everywhere in the file at [path].
  ///
  /// [existing] can be plain text or a [RegExp]. Gives back how many places
  /// were changed; the file is only written when that is more than 0.
  int replace(String path, Pattern existing, String replacement) {
    if (!isFile(path)) throw FileError('No file to change', path);

    final file = File(path);
    final text = file.readAsStringSync();
    final count = existing.allMatches(text).length;
    if (count > 0)
      file.writeAsStringSync(text.replaceAll(existing, replacement));

    return count;
  }

  /// The size of the file at [path], in bytes.
  int fileLength(String path) => File(path).lengthSync();

  /// When the file or folder at [path] was last changed.
  DateTime lastModified(String path) => FileStat.statSync(path).modified;

  /// Prints the folder at [path] as a tree, with lines from [AnsiTheme].
  ///
  /// Folders are bold in the theme's highlight colour, and the lines use its
  /// border colour. [maxDepth] limits how deep it goes; hidden files (whose
  /// names start with a dot) only show when [showHidden] is true.
  ///
  /// ```text
  /// lib
  /// ├─ src
  /// │  ╰─ cli.dart
  /// ╰─ example.dart
  /// ```
  void showTree(String path, {int maxDepth = 8, bool showHidden = false}) {
    if (!isDirectory(path)) throw FileError('No folder to show', path);

    final theme = AnsiTheme.current;
    AnsiTheme.say(basename(absolute(path)).bold.foreground(theme.highlight));
    _treeLines(path, '', maxDepth, showHidden).forEach(AnsiTheme.say);
  }

  /// The tree lines for everything inside [path], each starting with [indent].
  List<String> _treeLines(
    String path,
    String indent,
    int depthLeft,
    bool showHidden,
  ) {
    if (depthLeft <= 0) return const [];

    final theme = AnsiTheme.current;
    final box = theme.box;
    final List<FileSystemEntity> entries;
    try {
      entries = Directory(path).listSync(followLinks: false)
        ..removeWhere((e) => !showHidden && basename(e.path).startsWith('.'))
        ..sort((a, b) => basename(a.path).compareTo(basename(b.path)));
    } on FileSystemException {
      final branch = '$indent${box.bottomLeft}${box.horizontal} ';

      return ['${branch.foreground(theme.border)}${'(no access)'.dim}'];
    }

    final lines = <String>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isLast = i == entries.length - 1;
      final branch = isLast ? box.bottomLeft : box.teeLeft;
      final name = basename(entry.path);
      final label = entry is Directory
          ? name.bold.foreground(theme.highlight)
          : name;
      lines.add(
        '${'$indent$branch${box.horizontal} '.foreground(theme.border)}$label',
      );

      if (entry is Directory) {
        final nextIndent = '$indent${isLast ? ' ' : box.vertical}  ';
        lines.addAll(
          _treeLines(entry.path, nextIndent, depthLeft - 1, showHidden),
        );
      }
    }

    return lines;
  }

  /// Finds files (or folders) whose names match a wildcard [pattern].
  ///
  /// The pattern can use `*` (any text), `?` (one character) and `[abc]` (one
  /// of these). A pattern without a separator matches just the name, like
  /// `*.dart`. One with a separator matches the path below [workingDirectory],
  /// like `src/*/*.dart`. On Windows the match ignores upper and lower case.
  ///
  /// * [workingDirectory]: where to look. Defaults to [pwd].
  /// * [recursive]: also look inside sub-folders.
  /// * [types]: what to give back. Only files by default.
  /// * [includeHidden]: also look at names that start with a dot.
  ///
  /// Folders that can't be opened are skipped.
  ///
  /// ```dart
  /// await for (final file in find('*.dart', workingDirectory: 'lib')) {
  ///   print(file);
  /// }
  /// final logs = await find('*.log').toList();
  /// ```
  Stream<String> find(
    String pattern, {
    String? workingDirectory,
    bool recursive = true,
    Set<FileSystemEntityType> types = const {FileSystemEntityType.file},
    bool includeHidden = false,
  }) async* {
    final root = absolute(workingDirectory ?? pwd);
    final matchPath = pattern.contains('/') || pattern.contains(r'\');
    final matcher = globToRegExp(pattern);

    final folders = [root];
    while (folders.isNotEmpty) {
      final folder = folders.removeLast();
      final List<FileSystemEntity> entries;
      try {
        entries = await Directory(folder).list(followLinks: false).toList();
      } on FileSystemException {
        continue;
      }

      for (final entry in entries) {
        final name = basename(entry.path);
        if (!includeHidden && name.startsWith('.')) continue;

        final type = entry is Link
            ? FileSystemEntityType.link
            : entry is Directory
            ? FileSystemEntityType.directory
            : FileSystemEntityType.file;
        if (recursive && type == FileSystemEntityType.directory) {
          folders.add(entry.path);
        }
        if (!types.contains(type)) continue;

        final checked = matchPath
            ? entry.path.substring(root.length + 1).replaceAll(r'\', '/')
            : name;
        if (matcher.hasMatch(checked)) yield entry.path;
      }
    }
  }

  /// Turns a wildcard pattern like `*.dart` into a [RegExp] that matches it.
  ///
  /// `*` matches any text without a separator, `?` one character and `[...]`
  /// one of a set. Separators in [pattern] can be `/` or `\`. Matching
  /// ignores case on Windows.
  RegExp globToRegExp(String pattern) {
    final out = StringBuffer('^');
    final glob = pattern.replaceAll(r'\', '/');
    for (var i = 0; i < glob.length; i++) {
      final char = glob[i];
      switch (char) {
        case '*':
          out.write('[^/]*');
        case '?':
          out.write('[^/]');
        case '[':
          final end = glob.indexOf(']', i + 1);
          if (end == -1) {
            out.write(r'\[');
          } else {
            var set = glob.substring(i + 1, end);
            if (set.startsWith('!')) set = '^${set.substring(1)}';
            out.write('[${set.replaceAll(r'\', r'\\')}]');
            i = end;
          }
        default:
          out.write(RegExp.escape(char));
      }
    }
    out.write(r'$');

    return RegExp(out.toString(), caseSensitive: !Platform.isWindows);
  }

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
    ShellCommand.directory = Directory.current.path;
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
}
