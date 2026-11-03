import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

class CMD {
  static FS get fs => const FS._();

  static Draw get draw => const Draw._();

  static Net get net => const Net._();

  static Prompt get prompt => const Prompt._();

  static Shell get shell => const Shell._();

  const CMD._();
}

class FS {
  const FS._();

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

  /// Prints the folder at [path] as a tree, with lines from [CliTheme].
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

    final theme = CliTheme.current;
    CliTheme.say(basename(absolute(path)).bold.foreground(theme.highlight));
    _treeLines(path, '', maxDepth, showHidden).forEach(CliTheme.say);
  }

  /// The tree lines for everything inside [path], each starting with [indent].
  List<String> _treeLines(
    String path,
    String indent,
    int depthLeft,
    bool showHidden,
  ) {
    if (depthLeft <= 0) return const [];

    final theme = CliTheme.current;
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
}

class Draw {
  const Draw._();

  /// [text] drawn inside a box made of the theme's line characters.
  ///
  /// The text can have several lines and its own styles; widths are measured
  /// without escape codes so the right edge lines up. An optional [title] sits
  /// in the top line. Print it with [CliTheme.say].
  ///
  /// ```dart
  /// CliTheme.say(box('Saved 3 files'.bold, title: 'Done'));
  /// // ╭─ Done ────────╮
  /// // │ Saved 3 files │
  /// // ╰───────────────╯
  /// ```
  String box(String text, {String? title}) {
    final theme = CliTheme.current;
    final chars = theme.box;
    final lines = text.split('\n');
    final titleWidth = title == null ? 0 : title.plain.length + 3;
    final width = math.max(
      lines.map((line) => line.plain.length).fold(0, math.max),
      titleWidth,
    );

    String edge(String text) => text.foreground(theme.border);

    final top = title == null
        ? edge(
            '${chars.topLeft}${chars.horizontal * (width + 2)}${chars.topRight}',
          )
        : '${edge('${chars.topLeft}${chars.horizontal} ')}${title.bold}'
              '${edge(' ${chars.horizontal * (width - titleWidth + 2)}${chars.topRight}')}';
    final bottom = edge(
      '${chars.bottomLeft}${chars.horizontal * (width + 2)}${chars.bottomRight}',
    );

    return [
      top,
      for (final line in lines)
        '${edge(chars.vertical)} ${padPlain(line, width)}$RESET '
            '${edge(chars.vertical)}',
      bottom,
    ].join('\n');
  }

  /// [text] padded with spaces to [width] visible characters.
  ///
  /// Escape codes don't count towards the width, so styled text pads
  /// correctly. With [right], the spaces go in front.
  String padPlain(String text, int width, {bool right = false}) {
    final spaces = ' ' * math.max(width - text.plain.length, 0);

    return right ? '$spaces$text' : '$text$spaces';
  }

  /// [rows] drawn as a table with the theme's line characters.
  ///
  /// Each cell can be any value, styled or not; widths are measured without
  /// escape codes so the columns line up. The [header] row is bold and has a
  /// line under it. Columns listed in [rightAligned] (counting from 0) line up
  /// on the right, which suits numbers. Print it with [CliTheme.say].
  ///
  /// ```dart
  /// CliTheme.say(table(
  ///   [['cli.dart', 84], ['menu.dart', 230]],
  ///   header: ['File', 'Lines'],
  ///   rightAligned: {1},
  /// ));
  /// ```
  String table(
    List<List<Object?>> rows, {
    List<Object?>? header,
    Set<int> rightAligned = const {},
  }) {
    final theme = CliTheme.current;
    final chars = theme.box;
    final allRows = [?header, ...rows];
    if (allRows.isEmpty) return '';

    final columns = allRows.map((row) => row.length).fold(0, math.max);
    final widths = List.filled(columns, 0);
    for (final row in allRows) {
      for (var i = 0; i < row.length; i++) {
        widths[i] = math.max(widths[i], '${row[i] ?? ''}'.plain.length);
      }
    }

    String edge(String text) => text.foreground(theme.border);
    String line(String left, String middle, String right) => edge(
      '$left${widths.map((w) => chars.horizontal * (w + 2)).join(middle)}$right',
    );
    String cells(List<Object?> row, {bool bold = false}) {
      final parts = [
        for (var i = 0; i < columns; i++)
          padPlain(
            bold
                ? '${i < row.length ? row[i] ?? '' : ''}'.bold
                : '${i < row.length ? row[i] ?? '' : ''}',
            widths[i],
            right: rightAligned.contains(i),
          ),
      ];

      return '${edge(chars.vertical)} '
          '${parts.join('$RESET ${edge(chars.vertical)} ')}$RESET '
          '${edge(chars.vertical)}';
    }

    return [
      line(chars.topLeft, chars.teeDown, chars.topRight),
      if (header != null) ...[
        cells(header, bold: true),
        line(chars.teeLeft, chars.cross, chars.teeRight),
      ],
      for (final row in rows) cells(row),
      line(chars.bottomLeft, chars.teeUp, chars.bottomRight),
    ].join('\n');
  }
}

class Net {
  const Net._();

  /// Downloads [url] and saves it to the file [saveTo].
  ///
  /// With [showProgress], a [ProgressBar] fills as the file arrives (or a
  /// spinner, if the server doesn't say how big it is). The Windows Terminal
  /// taskbar icon shows the progress too. It ends with a themed tick line, or
  /// a cross line if the download fails.
  ///
  /// Missing folders for [saveTo] are created. An existing file is replaced
  /// only when [overwrite] is true. Throws a [FileError] if the file is there
  /// already, and an [HttpException] if the server doesn't answer with 200 OK.
  ///
  /// ```dart
  /// await fetch(
  ///   'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
  ///   join(pwd, 'build', 'VERSION.json'),
  /// );
  /// ```
  Future<void> fetch(
    String url,
    String saveTo, {
    bool showProgress = true,
    bool overwrite = false,
  }) async {
    if (!overwrite && CMD.fs.exists(saveTo))
      throw FileError('Already exists', saveTo);

    final theme = CliTheme.current;
    final name = CMD.fs.basename(saveTo);
    final client = HttpClient();
    final partial = File('$saveTo.part');
    ProgressBar? bar;

    try {
      final response = await (await client.getUrl(Uri.parse(url))).close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'The server answered ${response.statusCode} ${response.reasonPhrase}',
          uri: Uri.parse(url),
        );
      }

      final total = response.contentLength;
      if (showProgress) {
        if (total > 0) {
          bar = ProgressBar('Downloading $name', total: total);
        } else {
          Logger.instance.startSpinner('Downloading $name');
        }
      }

      CMD.fs.createDir(CMD.fs.dirname(saveTo));
      final sink = partial.openWrite();
      var received = 0;
      var lastPercent = -1;
      try {
        await for (final chunk in response) {
          sink.add(chunk);
          received += chunk.length;
          if (bar == null) continue;

          bar.update(received);
          final percent = received * 100 ~/ total;
          if (percent != lastPercent) {
            lastPercent = percent;
            stdout.write(taskbarProgress(percent));
          }
        }
      } finally {
        await sink.close();
      }

      if (CMD.fs.exists(saveTo)) File(saveTo).deleteSync();
      partial.renameSync(saveTo);

      if (showProgress) {
        _endProgress(bar);
        CliTheme.say(theme.successLine('Downloaded ${name.bold}'));
      }
    } catch (_) {
      if (showProgress) {
        _endProgress(bar);
        CliTheme.say(theme.errorLine('Download failed: ${url.dim}'));
      }
      if (partial.existsSync()) partial.deleteSync();
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Wipes the bar or spinner and clears the taskbar progress.
  void _endProgress(ProgressBar? bar) {
    stdout.write(TASKBAR_CLEAR);
    if (bar != null) {
      // Leave no PASS/FAIL line from the bar; fetch prints its own.
      stdout.write('$CLEAR_LINE$SHOW_CURSOR');
    } else if (Logger.instance.isSpinning) {
      Logger.instance.stopSpinner(null, Level.log);
    }
  }
}

class Prompt {
  const Prompt._();

  /// Asks the user a question and gives back what they type.
  ///
  /// The question is drawn with [CliTheme.current]. A wrong answer shows an
  /// error line and asks again.
  ///
  /// * [defaultValue]: used when the user just presses Enter. Shown dim after
  ///   the question.
  /// * [hidden]: don't show what is typed, for passwords.
  /// * [required]: an empty answer isn't allowed (unless there's a default).
  /// * [validator]: gives back a problem to show, or null if the answer is ok.
  ///
  /// ```dart
  /// final name = ask('Project name', defaultValue: 'my_app');
  /// final port = ask('Port', validator: (a) =>
  ///     int.tryParse(a) == null ? 'Type a number' : null);
  /// final secret = ask('Password', hidden: true);
  /// ```
  String ask(
    String prompt, {
    String? defaultValue,
    bool hidden = false,
    bool required = true,
    String? Function(String answer)? validator,
  }) {
    return PromptLine.run<String>(
      prompt,
      hint: defaultValue == null || hidden ? '' : '($defaultValue)',
      hidden: hidden,
      shown: (answer) => hidden ? BULLET * answer.length : answer,
      check: (typed) {
        final answer = typed.isEmpty ? defaultValue ?? '' : typed;
        final problem = answer.isEmpty && required
            ? 'An answer is needed'
            : validator?.call(answer);

        return (value: answer, problem: problem);
      },
    );
  }

  /// Asks a yes or no question and gives back true for yes.
  ///
  /// A dim `[Y/n]` hint shows which answer Enter picks when there is a
  /// [defaultValue]; without one, the user must type y or n.
  ///
  /// ```dart
  /// if (confirm('Delete the build folder?', defaultValue: false)) {
  ///   deleteDir('build');
  /// }
  /// ```
  bool confirm(String prompt, {bool? defaultValue}) {
    final hint = switch (defaultValue) {
      true => '[Y/n]',
      false => '[y/N]',
      null => '[y/n]',
    };

    return PromptLine.run<bool>(
      prompt,
      hint: hint,
      shown: (yes) => yes ? 'Yes' : 'No',
      check: (typed) {
        final answer = switch (typed.toLowerCase()) {
          'y' || 'yes' => true,
          'n' || 'no' => false,
          '' => defaultValue,
          _ => null,
        };

        return (
          value: answer,
          problem: answer == null ? 'Please type y or n' : null,
        );
      },
    );
  }

  /// Lets the user pick one of [options] and gives back the one they picked.
  ///
  /// In a terminal, the options are a list you move through with the arrow
  /// keys (or `j`/`k`), and pick with Enter. Number keys jump straight to an
  /// option. The current row shows the theme's pointer in its highlight
  /// colour. When there's no terminal (or colour is off) it falls back to a
  /// numbered list and asks for a number.
  ///
  /// * [format]: how each option is shown. Defaults to `toString()`.
  /// * [defaultOption]: the option picked at the start.
  ///
  /// ```dart
  /// final colour = menu('Pick a colour', ['Red', 'Green', 'Blue']);
  /// final file = menu('Open which file?', files, format: basename);
  /// ```
  T menu<T>(
    String prompt,
    List<T> options, {
    String Function(T option)? format,
    T? defaultOption,
  }) {
    if (options.isEmpty) throw ArgumentError.value(options, 'options', 'Empty');

    final labels = [
      for (final option in options) format?.call(option) ?? '$option',
    ];
    final start = math.max(
      defaultOption == null ? 0 : options.indexOf(defaultOption),
      0,
    );

    final interactive =
        CliTheme.useColour && stdin.hasTerminal && stdout.hasTerminal;
    final picked = interactive
        ? _MenuScreen(prompt, labels, start).run()
        : _numberedMenu(prompt, labels, start);

    return options[picked];
  }

  /// Prints the options as a numbered list and asks for a number.
  int _numberedMenu(String prompt, List<String> labels, int start) {
    final theme = CliTheme.current;
    CliTheme.say(
      '${'?'.foreground(theme.hint)} '
      '${prompt.bold.foreground(theme.question)}',
    );
    for (var i = 0; i < labels.length; i++) {
      CliTheme.say('  ${'${i + 1})'.foreground(theme.hint)} ${labels[i]}');
    }

    final number = PromptLine.run<int>(
      'Number',
      hint: '(${start + 1})',
      shown: (index) => labels[index],
      check: (typed) {
        if (typed.isEmpty) return (value: start, problem: null);
        final index = (int.tryParse(typed) ?? 0) - 1;
        final ok = index >= 0 && index < labels.length;

        return (
          value: ok ? index : null,
          problem: ok ? null : 'Type a number from 1 to ${labels.length}',
        );
      },
    );

    return number;
  }
}

/// The arrow-key menu, drawn and redrawn in place.
class _MenuScreen {
  final String prompt;
  final List<String> labels;
  int selected;

  /// The first option shown, when there are more options than fit.
  int _top = 0;

  /// How many option rows were drawn last time, to move back over them.
  int _drawnRows = 0;

  /// The option a number key picked, counting from 0.
  int _number = 0;

  _MenuScreen(this.prompt, this.labels, this.selected);

  /// How many options fit on screen at once.
  int get _pageSize {
    final rows = stdout.hasTerminal ? stdout.terminalLines : 24;

    return math.min(labels.length, math.max(rows - 2, 3));
  }

  /// Shows the menu, reads keys until Enter, and gives back the picked index.
  int run() {
    final theme = CliTheme.current;
    final question = prompt.bold.foreground(theme.question);
    stdout.write(
      '${'?'.foreground(theme.hint)} $question '
      '${'(↑/↓ and Enter)'.dim.foreground(theme.hint)}\n$HIDE_CURSOR',
    );

    final echo = stdin.echoMode;
    final line = stdin.lineMode;
    // Windows needs echo off before line mode can be turned off.
    stdin
      ..echoMode = false
      ..lineMode = false;
    try {
      _draw();
      while (true) {
        final key = _readKey();
        if (key == _Key.enter) break;
        if (key == _Key.cancel) {
          _restore(echo, line);
          exit(130);
        }
        if (key == _Key.up) selected = (selected - 1) % labels.length;
        if (key == _Key.down) selected = (selected + 1) % labels.length;
        if (key == _Key.number && _number < labels.length) selected = _number;
        _draw();
      }
    } finally {
      _restore(echo, line);
    }

    // Swap the whole menu for one line with the answer.
    final done =
        '${theme.tick.foreground(theme.success)} $question '
        '${labels[selected].plain.foreground(theme.answer)}';
    stdout.write('${cursorUp(_drawnRows + 1)}\r$CLEAR_TO_SCREEN_END$done\n');

    return selected;
  }

  /// Draws the visible options, replacing the ones drawn before.
  void _draw() {
    final theme = CliTheme.current;
    final page = _pageSize;
    if (selected < _top) _top = selected;
    if (selected >= _top + page) _top = selected - page + 1;

    final width = stdout.hasTerminal ? stdout.terminalColumns - 4 : 76;
    final out = StringBuffer(SYNC_START);
    if (_drawnRows > 0) out.write('${cursorUp(_drawnRows)}\r');
    out.write(CLEAR_TO_SCREEN_END);

    for (var i = _top; i < _top + page; i++) {
      final label = _fit(labels[i], width);
      if (i == selected) {
        out.write(
          '${'${theme.pointer} $label'.bold.foreground(theme.highlight)}\n',
        );
      } else {
        out.write('  $label$RESET\n');
      }
    }
    out.write(SYNC_END);
    _drawnRows = page;
    stdout.write(out);
  }

  /// [label] cut down to [width] visible characters, ending in an ellipsis.
  ///
  /// The length is measured without escape codes, so styled labels aren't
  /// cut short. A label that needs cutting loses its styles.
  String _fit(String label, int width) {
    final plain = label.plain;
    if (plain.length <= width || width < 2) return label;

    return '${plain.substring(0, width - 1)}$ELLIPSIS';
  }

  /// Puts the terminal back the way it was and shows the cursor.
  void _restore(bool echo, bool line) {
    // Line mode must come back before echo on Windows.
    stdin
      ..lineMode = line
      ..echoMode = echo;
    stdout.write(SHOW_CURSOR);
  }

  /// Reads one key press and works out what it means.
  _Key _readKey() {
    final byte = stdin.readByteSync();
    switch (byte) {
      case -1 || 3:
        // Input closed, or Ctrl+C.
        return _Key.cancel;
      case 10 || 13:
        return _Key.enter;
      case 27:
        // ESC [ A is up and ESC [ B is down (ESC O A/B on some terminals).
        final second = stdin.readByteSync();
        if (second != 0x5B && second != 0x4F) return _Key.other;

        return _arrow(stdin.readByteSync(), up: 0x41, down: 0x42);
      case 0 || 0xE0:
        // Older Windows consoles send 0xE0 then H for up or P for down.
        return _arrow(stdin.readByteSync(), up: 0x48, down: 0x50);
      case 0x6B || 0x77:
        // k or w
        return _Key.up;
      case 0x6A || 0x73:
        // j or s
        return _Key.down;
      case final digit when digit >= 0x31 && digit <= 0x39:
        _number = digit - 0x31;

        return _Key.number;
      default:
        return _Key.other;
    }
  }

  /// Up, down or nothing, depending on whether [byte] is [up] or [down].
  _Key _arrow(int byte, {required int up, required int down}) {
    if (byte == up) return _Key.up;
    if (byte == down) return _Key.down;

    return _Key.other;
  }
}

/// A key press the menu cares about.
enum _Key { up, down, enter, cancel, number, other }

/// What a prompt's check makes of the typed text.
///
/// Either a [value] to give back, or a [problem] to show before asking again.
typedef PromptCheck<T> = ({T? value, String? problem}) Function(String typed);

/// Asks one question on one line until the answer passes a check.
///
/// Used by [ask], [confirm] and the plain [menu]. With colour on, a wrong
/// answer shows a themed error line under the question, and the question is
/// redrawn in place. Once answered, the line is redrawn with a tick and the
/// answer in the theme's answer colour.
class PromptLine {
  const PromptLine._();

  /// Shows [question] (with an optional dim [hint]) until [check] accepts.
  ///
  /// [shown] turns the accepted value into the text echoed after the
  /// question. With [hidden], typing isn't shown on screen. If input ends
  /// (stdin is closed), [check] gets an empty string, and if that isn't
  /// accepted a [StdinException] is thrown.
  static T run<T>(
    String question, {
    required PromptCheck<T> check,
    required String Function(T value) shown,
    String hint = '',
    bool hidden = false,
  }) {
    final theme = CliTheme.current;
    final fancy = CliTheme.useColour && stdout.hasTerminal;
    final text = question.bold.foreground(theme.question);
    final hintText = hint.isEmpty ? '' : ' ${hint.dim.foreground(theme.hint)}';
    final asked = '${'?'.foreground(theme.hint)} $text$hintText ';

    var showingProblem = false;
    while (true) {
      CliTheme.write(asked);
      final typed = _readLine(hidden: hidden);
      final result = check(typed?.trim() ?? '');

      // Wipe the old error line under the question.
      if (fancy && showingProblem) stdout.write('\r$CLEAR_TO_SCREEN_END');

      final value = result.value;
      if (result.problem == null && value is T) {
        if (fancy) {
          final done =
              '${theme.tick.foreground(theme.success)} $text '
              '${shown(value).foreground(theme.answer)}';
          stdout.write('${cursorUp()}\r$CLEAR_LINE$done$RESET\n');
        }

        return value;
      }
      if (typed == null) {
        throw const StdinException('Input ended before an answer was given');
      }

      final problem = theme.errorLine(result.problem ?? 'Try again');
      if (fancy) {
        // Show the error under the question, then go back up to ask again.
        stdout.write('$problem${cursorUp()}\r$CLEAR_LINE');
        showingProblem = true;
      } else {
        CliTheme.say(problem);
      }
    }
  }

  /// Reads one line from stdin, hiding what is typed if [hidden] is true.
  ///
  /// Gives back null when stdin has closed.
  static String? _readLine({required bool hidden}) {
    if (!hidden || !stdin.hasTerminal) return stdin.readLineSync();

    final echo = stdin.echoMode;
    stdin.echoMode = false;
    try {
      return stdin.readLineSync();
    } finally {
      stdin.echoMode = echo;
      // Enter wasn't shown either, so move to the next line ourselves.
      stdout.writeln();
    }
  }
}

class Shell {
  const Shell._();

  /// Whether your app is running as administrator (Windows) or root (Mac and
  /// Linux).
  ///
  /// Worked out once and remembered.
  ///
  /// ```dart
  /// if (!await isPrivilegedUser) {
  ///   CliTheme.say(CliTheme.current.errorLine('Please run this as admin'));
  /// }
  /// ```
  Future<bool> get isPrivilegedUser async => await _check();

  /// Runs your app again as administrator or root, with the same arguments.
  ///
  /// On Windows, Windows asks the user first and the app opens in a new
  /// window. Elsewhere it runs through `sudo` in this terminal. Gives back the
  /// new run's exit code; your app should usually exit with it straight after.
  ///
  /// Does nothing and gives back 0 if the app already has these rights.
  ///
  /// ```dart
  /// void main(List<String> args) async {
  ///   if (!await isPrivilegedUser) exit(await withPrivileges(args));
  ///   // ... admin work ...
  /// }
  /// ```
  Future<int> withPrivileges(List<String> arguments) async {
    if (await isPrivilegedUser) return 0;

    final program = Platform.resolvedExecutable;
    final script = Platform.script.toFilePath();
    final isCompiled = script == program || !script.endsWith('.dart');
    final args = [if (!isCompiled) script, ...arguments];

    if (Platform.isWindows) {
      return openInNewWindow(
        program,
        args: args,
        workingDirectory: CMD.fs.pwd,
        asAdmin: true,
        wait: true,
      );
    }

    final process = await Process.start('sudo', [
      program,
      ...args,
    ], mode: ProcessStartMode.inheritStdio);

    return process.exitCode;
  }

  /// Asks the system whether this process has admin or root rights.
  Future<bool> _check() async {
    try {
      if (Platform.isWindows) {
        // "net session" only works for administrators.
        final result = await Process.run('net', ['session']);

        return result.exitCode == 0;
      }
      final result = await Process.run('id', ['-u']);

      return result.output.trim() == '0';
    } on ProcessException {
      return false;
    }
  }
}

/// Runs this string as a terminal command, through [TerminalCommand].
///
/// The command goes to a shell, so pipes, `cd` and variables all work, and
/// the folder carries over between commands. It runs with [env].
///
/// When a command fails, a themed error line is printed and a
/// [ProcessFailed] is thrown, unless you use [start] with `nothrow: true`.
/// In verbose mode ([Logger.verbose]), each command is shown first as a dim
/// `➜ command` line.
///
/// ```dart
/// await 'git pull'.run;
/// final files = await 'git ls-files'.toList();
/// final branch = await 'git branch --show-current'.firstLine;
/// await 'dart test'.forEach((line) => print(line.toUpperCase()));
/// ```
extension StringRun on String {
  /// Runs the command, showing what it prints.
  ///
  /// Throws a [ProcessFailed] if it fails.
  Future<ProcessResult> get run => start();

  /// Runs the command with options.
  ///
  /// * [show]: print what the command prints as it runs.
  /// * [interactive]: hand the keyboard over, for commands that ask things.
  /// * [nothrow]: give back a failed result instead of throwing.
  /// * [shell]: the shell to use. Defaults to [TerminalCommand.defaultShell].
  Future<ProcessResult> start({
    bool show = true,
    bool interactive = false,
    bool nothrow = false,
    TerminalShell? shell,
  }) async {
    final theme = CliTheme.current;
    if (Logger.instance.verbose) {
      CliTheme.say('${theme.pointer} $this'.dim.foreground(theme.hint));
    }

    final result = await TerminalCommand.run(
      this,
      shell: shell,
      show: show,
      interactive: interactive,
    );
    if (result.ok) return result;

    if (show) {
      CliTheme.say(
        theme.errorLine('Failed with exit code ${result.exitCode}: ') +
            '$this'.bold.foreground(theme.error),
      );
    }
    if (!nothrow) throw ProcessFailed(result);

    return result;
  }

  /// Runs the command quietly and gives back the lines it printed.
  ///
  /// Empty lines are left out. Throws a [ProcessFailed] if it fails, unless
  /// [nothrow] is true.
  Future<List<String>> toList({bool nothrow = false}) async =>
      (await start(show: false, nothrow: nothrow)).lines;

  /// Runs the command quietly and gives back the first line it printed.
  ///
  /// Null if it printed nothing. Throws a [ProcessFailed] if it fails.
  Future<String?> get firstLine async {
    final lines = await toList();

    return lines.isEmpty ? null : lines.first;
  }

  /// Runs the command quietly and calls [action] with each line it printed.
  ///
  /// Throws a [ProcessFailed] if it fails.
  Future<void> forEach(void Function(String line) action) async =>
      (await toList()).forEach(action);
}
