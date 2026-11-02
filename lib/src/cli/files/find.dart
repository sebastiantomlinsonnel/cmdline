import 'dart:io';

import 'package:cmdline/cmdline.dart';

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
