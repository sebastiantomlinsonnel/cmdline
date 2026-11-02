import 'dart:io';

import 'package:cmdline/cmdline.dart';

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
  if (count > 0) file.writeAsStringSync(text.replaceAll(existing, replacement));

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
