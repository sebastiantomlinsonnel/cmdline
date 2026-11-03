import 'dart:io';
import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

class CMD {
  static FS get fs => const FS._();

  static Draw get draw => const Draw._();
  static Net get net => const Net._();

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

    final target = isDirectory(to) ? join(to, basename(from)) : to;
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
    final name = basename(saveTo);
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

      CMD.fs.createDir(dirname(saveTo));
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