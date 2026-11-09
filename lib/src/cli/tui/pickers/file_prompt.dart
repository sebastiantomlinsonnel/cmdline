// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:io';

import '../../../../cmdline.dart';

/// What a file picker gives back: files, folders, or either.
///
/// {@category cli}
enum PathKind {
  /// Only files can be picked.
  file,

  /// Only folders can be picked.
  folder,

  /// Files or folders.
  any,
}

/// Browse folders and pick a file (or folder).
///
/// Enter or right opens a folder, left or Backspace goes up, and typing
/// filters what's shown. To pick a folder, open it and choose `Use this
/// folder` at the top. Gives back the full path.
///
/// {@category cli}
class FilePrompt extends PromptView<String> {
  /// What may be picked.
  final PathKind kind;

  /// Only files ending in one of these are shown, like `['.dart', '.yaml']`.
  /// Empty shows all files.
  final List<String> extensions;

  /// Whether names starting with a dot are shown.
  final bool showHidden;

  /// The folder shown at the start.
  final String startFolder;

  Directory _folder;
  List<FileSystemEntity> _entries = [];
  List<_Row> _rows = [];
  final TextBuffer _filter = TextBuffer();
  late final ListCursor _cursor;
  String? _picked;

  /// Creates a file picker asking [question], starting in [folder] (or the
  /// working folder).
  FilePrompt(
    super.question, {
    String? folder,
    this.kind = PathKind.file,
    this.extensions = const [],
    this.showHidden = false,
  }) : startFolder = Directory(folder ?? Directory.current.path).absolute.path,
       _folder = Directory(folder ?? Directory.current.path).absolute {
    _cursor = ListCursor(0, pageSize: pageSizeFor(1000, reserved: 5), wrap: false);
    _load();
  }

  static String _name(FileSystemEntity entity) {
    final parts = entity.path.split(RegExp(r'[\\/]')).where((p) => p.isNotEmpty);

    return parts.isEmpty ? entity.path : parts.last;
  }

  void _load() {
    try {
      _entries = _folder.listSync(followLinks: false).where((entity) {
        final name = _name(entity);
        if (!showHidden && name.startsWith('.')) return false;
        if (entity is Directory) return true;
        if (kind == PathKind.folder) return false;

        return extensions.isEmpty ||
            extensions.any((ext) => name.toLowerCase().endsWith(ext.toLowerCase()));
      }).toList()
        ..sort((a, b) {
          final folders = (b is Directory ? 1 : 0) - (a is Directory ? 1 : 0);

          return folders != 0 ? folders : _name(a).toLowerCase().compareTo(_name(b).toLowerCase());
        });
    } on FileSystemException catch (problem) {
      _entries = [];
      error = 'Can\'t open ${_folder.path}: ${problem.osError?.message ?? problem.message}';
    }
    _filter.clear();
    _refilter();
  }

  void _refilter() {
    final query = _filter.text;
    final hasParent = _folder.parent.path != _folder.path;
    _rows = [
      if (kind != PathKind.file && query.isEmpty) const _Row.useFolder(),
      if (hasParent && query.isEmpty) const _Row.up(),
      for (final entity in _entries)
        if (Fuzzy.match(query, _name(entity)) != null) _Row(entity),
    ];
    _cursor.resize(_rows.length, reset: true);
  }

  String _label(_Row row) {
    final glyphs = theme.glyphs;
    final entity = row.entity;
    if (row.isUseFolder) return '${theme.tick} Use this folder'.foreground(theme.success);
    if (entity == null) return '${glyphs.folder} ..'.foreground(theme.info);
    final name = _name(entity);

    return entity is Directory
        ? '${glyphs.folder} $name${Platform.pathSeparator}'.foreground(theme.info)
        : '${glyphs.file} $name';
  }

  @override
  String inline() => _filter.isEmpty ? muted(_folder.path) : _filter.text;

  @override
  int? get inlineCursor => _filter.isEmpty ? null : _filter.beforeCursor.width;

  @override
  List<String> body() {
    if (_rows.isEmpty) return [muted('  Nothing here')];
    final columns = Terminal.current.columns - 1;

    return [
      ?moreLine(_cursor.top, above: true),
      for (var i = _cursor.top; i < _cursor.bottom; i++)
        (i == _cursor.index ? pointed(_label(_rows[i])) : unpointed(_label(_rows[i])))
            .fitWidth(columns),
      ?moreLine(_rows.length - _cursor.bottom, above: false),
    ];
  }

  @override
  List<KeyHint> get keys => const [
    ('↑↓', 'move'),
    ('enter →', 'open/pick'),
    ('← bksp', 'up'),
    ('type', 'filter'),
    ('esc', 'cancel'),
  ];

  void _open(Directory folder) {
    _folder = folder.absolute;
    _load();
  }

  @override
  KeyResult onKey(KeyPress press) {
    if (_cursor.handle(press)) return KeyResult.handled;
    final row = _rows.isEmpty ? null : _rows[_cursor.index];
    switch (press.key) {
      case Key.enter || Key.right when row != null:
        final entity = row.entity;
        if (row.isUseFolder) {
          _picked = _folder.path;

          return KeyResult.done;
        }
        if (entity == null) {
          _open(_folder.parent);
        } else if (entity is Directory) {
          _open(entity);
        } else if (press.key == Key.enter) {
          _picked = entity.absolute.path;

          return KeyResult.done;
        }

        return KeyResult.handled;
      case Key.left || Key.backspace when _filter.isEmpty:
        if (_folder.parent.path != _folder.path) _open(_folder.parent);

        return KeyResult.handled;
      case Key.escape when !_filter.isEmpty:
        _filter.clear();
        _refilter();

        return KeyResult.handled;
      default:
        if (!_filter.handle(press)) return KeyResult.ignored;
        _refilter();

        return KeyResult.handled;
    }
  }

  @override
  String get result => _picked ?? _folder.path;

  @override
  String get fallbackHint => '(path)';

  @override
  ({String? value, String? problem}) parse(String typed) =>
      PathPrompt.check(typed, kind: kind, mustExist: true, base: startFolder);

  @override
  String? get unattended => null;
}

/// One row of the file picker.
class _Row {
  final FileSystemEntity? entity;
  final bool isUseFolder;

  const _Row(FileSystemEntity this.entity) : isUseFolder = false;
  const _Row.up() : entity = null, isUseFolder = false;
  const _Row.useFolder() : entity = null, isUseFolder = true;
}

/// Type a path, with Tab completing file and folder names.
///
/// Tab fills in as much of the name as is shared by everything that
/// matches; matches show under the box.
///
/// {@category cli}
class PathPrompt extends PromptView<String> {
  /// What the path must point to.
  final PathKind kind;

  /// Whether the path must already exist.
  final bool mustExist;

  /// The path at the start, and the answer in [PromptMode.unattended].
  final String? defaultValue;

  final TextBuffer _input;
  List<String> _matches = const [];

  /// Creates a path box asking [question].
  PathPrompt(
    super.question, {
    this.kind = PathKind.any,
    this.mustExist = true,
    this.defaultValue,
  }) : _input = TextBuffer(defaultValue ?? '');

  /// Checks a typed [path]: gives back the full path, or a problem.
  static ({String? value, String? problem}) check(
    String path, {
    required PathKind kind,
    required bool mustExist,
    String? base,
  }) {
    if (path.trim().isEmpty) return (value: null, problem: 'Type a path');
    var full = path.trim();
    if (base != null && !File(full).isAbsolute) full = '$base${Platform.pathSeparator}$full';
    final type = FileSystemEntity.typeSync(full);
    if (type == FileSystemEntityType.notFound) {
      return mustExist
          ? (value: null, problem: 'Nothing at $path')
          : (value: File(full).absolute.path, problem: null);
    }
    final isFolder = type == FileSystemEntityType.directory;
    if (kind == PathKind.file && isFolder) return (value: null, problem: 'That is a folder');
    if (kind == PathKind.folder && !isFolder) return (value: null, problem: 'That is not a folder');

    return (value: File(full).absolute.path, problem: null);
  }

  /// The names in the typed folder that start with the typed name.
  List<String> _complete(String typed) {
    final cut = typed.lastIndexOf(RegExp(r'[\\/]'));
    final folder = cut < 0 ? '.' : (cut == 0 ? typed.substring(0, 1) : typed.substring(0, cut));
    final start = typed.substring(cut + 1).toLowerCase();
    try {
      return [
        for (final entity in Directory(folder).listSync(followLinks: false))
          if (FilePrompt._name(entity).toLowerCase().startsWith(start) &&
              (kind != PathKind.folder || entity is Directory))
            '${cut < 0 ? '' : typed.substring(0, cut + 1)}${FilePrompt._name(entity)}'
                '${entity is Directory ? Platform.pathSeparator : ''}',
      ]..sort();
    } on FileSystemException {
      return const [];
    }
  }

  @override
  String inline() => _input.isEmpty ? muted('type a path, tab completes') : _input.text;

  @override
  int? get inlineCursor => _input.beforeCursor.width;

  @override
  List<String> body() => [
    if (_matches.length > 1)
      '  ${muted(_matches.take(8).map((m) => m.split(RegExp(r'[\\/]')).where((p) => p.isNotEmpty).last).join('  '))}'
          '${_matches.length > 8 ? muted('  +${_matches.length - 8}') : ''}',
  ];

  @override
  List<KeyHint> get keys => const [
    ('tab', 'complete'),
    ('enter', 'submit'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    switch (press.key) {
      case Key.tab:
        final matches = _complete(_input.text);
        _matches = matches;
        if (matches.isEmpty) return KeyResult.handled;
        var shared = matches.first;
        for (final match in matches.skip(1)) {
          var i = 0;
          while (i < shared.length && i < match.length &&
              shared[i].toLowerCase() == match[i].toLowerCase()) {
            i++;
          }
          shared = shared.substring(0, i);
        }
        if (shared.length > _input.text.length) _input.text = shared;
        if (matches.length == 1) _matches = const [];

        return KeyResult.handled;
      case Key.enter:
        final checked = check(_input.text, kind: kind, mustExist: mustExist);
        if (checked.problem != null) {
          error = checked.problem;

          return KeyResult.handled;
        }

        return KeyResult.done;
      default:
        _matches = const [];

        return _input.handle(press) ? KeyResult.handled : KeyResult.ignored;
    }
  }

  @override
  String get result => check(_input.text, kind: kind, mustExist: mustExist).value ?? _input.text;

  @override
  String get fallbackHint => defaultValue == null ? '' : '($defaultValue)';

  @override
  ({String? value, String? problem}) parse(String typed) =>
      check(typed.isEmpty ? defaultValue ?? '' : typed, kind: kind, mustExist: mustExist);

  @override
  String? get unattended {
    final value = defaultValue;

    return value == null ? null : check(value, kind: kind, mustExist: mustExist).value;
  }
}
