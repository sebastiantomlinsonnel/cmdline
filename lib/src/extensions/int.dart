import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Quick base-conversion getters on non-nullable [int].
///
/// These turn any integer into its string representation in common numeral
/// bases — perfect for debugging, encoding, or display purposes.
///
/// ```dart
/// 255.hex  // 'FF'
/// 42.bin   // '101010'
/// 255.oct  // '377'
/// 255.b256 // base-256 encoded string
/// ```
extension Int on int? {
  /// Returns this value if non-null, otherwise returns [value] (defaults to `0`).
  int validate({int value = 0}) {
    return this ?? value;
  }

  /// Returns `true` if this integer is a successful HTTP status code
  /// (200-206 inclusive).
  ///
  /// ```dart
  /// 200.isSuccessful() // true
  /// 404.isSuccessful() // false
  /// ```
  bool isSuccessful() => this! >= 200 && this! <= 206;

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: validate());

  /// Returns if a number is between `first` and `second`
  /// ```dart
  /// 100.isBetween(50, 150) // true;
  /// 100.isBetween(100, 100) // true;
  /// ```
  bool isBetween(num first, num second) {
    if (first <= second) {
      return validate() >= first && validate() <= second;
    } else {
      return validate() >= second && validate() <= first;
    }
  }

  /// Returns the day number with its ordinal suffix (`st`, `nd`, `rd`, `th`).
  ///
  /// Only valid for day-of-month values (1-31). Throws if out of range.
  ///
  /// ```dart
  /// 1.toMonthDaySuffix()  // '1 st'
  /// 22.toMonthDaySuffix() // '22 nd'
  /// 11.toMonthDaySuffix() // '11 th' (special case for teens)
  /// ```
  String toMonthDaySuffix() {
    if (!(this! >= 1 && this! <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (this! >= 11 && this! <= 13) {
      return '$this th';
    }

    switch (this! % 10) {
      case 1:
        return '$this st';
      case 2:
        return '$this nd';
      case 3:
        return '$this rd';
      default:
        return '$this th';
    }
  }

  /// Converts a month number (1-12) to its full or abbreviated name.
  ///
  /// Set [isHalfName] to `true` for the three-letter abbreviation.
  ///
  /// ```dart
  /// 3.toMonthName()                    // 'March'
  /// 3.toMonthName(isHalfName: true)    // 'Mar'
  /// ```
  String toMonthName({bool isHalfName = false}) {
    String status = '';
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }
    if (this == 1) {
      return status = isHalfName ? 'Jan' : 'January';
    } else if (this == 2) {
      return status = isHalfName ? 'Feb' : 'February';
    } else if (this == 3) {
      return status = isHalfName ? 'Mar' : 'March';
    } else if (this == 4) {
      return status = isHalfName ? 'Apr' : 'April';
    } else if (this == 5) {
      return status = isHalfName ? 'May' : 'May';
    } else if (this == 6) {
      return status = isHalfName ? 'Jun' : 'June';
    } else if (this == 7) {
      return status = isHalfName ? 'Jul' : 'July';
    } else if (this == 8) {
      return status = isHalfName ? 'Aug' : 'August';
    } else if (this == 9) {
      return status = isHalfName ? 'Sept' : 'September';
    } else if (this == 10) {
      return status = isHalfName ? 'Oct' : 'October';
    } else if (this == 11) {
      return status = isHalfName ? 'Nov' : 'November';
    } else if (this == 12) {
      return status = isHalfName ? 'Dec' : 'December';
    }
    return status;
  }

  /// Converts a weekday number (1 = Monday, 7 = Sunday) to its name.
  ///
  /// Set [isHalfName] to `true` for three-letter abbreviations.
  ///
  /// ```dart
  /// 1.toWeekDay()                   // 'Monday'
  /// 1.toWeekDay(isHalfName: true)   // 'Mon'
  /// ```
  String toWeekDay({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }
    String weekName = '';

    if (this == 1) {
      return weekName = isHalfName ? "Mon" : "Monday";
    } else if (this == 2) {
      return weekName = isHalfName ? "Tue" : "Tuesday";
    } else if (this == 3) {
      return weekName = isHalfName ? "Wed" : "Wednesday";
    } else if (this == 4) {
      return weekName = isHalfName ? "Thu" : "Thursday";
    } else if (this == 5) {
      return weekName = isHalfName ? "Fri" : "Friday";
    } else if (this == 6) {
      return weekName = isHalfName ? "Sat" : "Saturday";
    } else if (this == 7) {
      return weekName = isHalfName ? "Sun" : "Sunday";
    }
    return weekName;
  }

  /// Returns true if given value is 1, else returns false
  bool getBoolInt() {
    if (this == 1) {
      return true;
    }
    return false;
  }
}

/// A type alias that makes font-family parameters self-documenting.
///
/// Instead of `String fontFamily`, you can write `Font fontFamily` — same
/// type, clearer intent.
typedef Font = String;

/// Singleton that discovers and indexes system fonts at runtime.
///
/// [SystemFonts] scans the platform's standard font directories (Windows,
/// Android, macOS, Linux) for `.ttf` and `.otf` files. In Flutter, the
/// `recollect` package adds `loadFont`, `loadAllFonts` and `loadFontFromPath`
/// so you can load them into Flutter's font engine on the fly — no need to
/// bundle every font in your asset manifest.
///
/// On Android the system font directories are read-only and hold only the
/// families the ROM ships (Roboto, Noto and friends), so expect a much shorter
/// list there than on desktop.
///
/// ## Getting Started
///
/// ```dart
/// final fonts = SystemFonts();
///
/// // See what's available
/// final allFonts = fonts.getFontList(); // ['Arial', 'Courier New', ...]
///
/// // Load one font for use in TextStyle (Flutter only)
/// await fonts.loadFont('Fira Code');
///
/// // Or load everything at once
/// await fonts.loadAllFonts();
/// ```
///
/// ## Custom Font Directories
///
/// If your fonts live somewhere non-standard, point the scanner there:
///
/// ```dart
/// fonts.addAdditionalFontDirectory('/opt/my-fonts/');
/// ```
///
/// ## How It Works
///
/// 1. On first access, the constructor scans platform-specific directories.
/// 2. [getFontPaths] lazily collects all `.ttf`/`.otf` file paths.
/// 3. [getFontMap] builds a `{name: path}` lookup from those paths.
/// 4. In Flutter, `loadFont` reads the bytes and registers them with
///    `FontLoader`. Loaded fonts are cached, so loading the same name twice
///    is a no-op the second time.
class SystemFonts {
  static final SystemFonts _instance = SystemFonts._internal();

  /// Returns the singleton [SystemFonts] instance.
  factory SystemFonts() {
    return _instance;
  }

  SystemFonts._internal() {
    _fontDirectories.addAll(_getFontDirectories());
  }

  final List<String> _fontDirectories = [];

  final List<String> _fontPaths = [];
  final Map<String, String> _fontMap = {};

  List<String> _getFontDirectories() {
    if (Platform.isWindows) {
      return [
        '${Platform.environment['windir']}/fonts/',
        '${Platform.environment['USERPROFILE']}/AppData/Local/Microsoft/Windows/Fonts/',
      ];
    }

    if (Platform.isAndroid) {
      // Android ships its fonts read-only under the system partitions. There is
      // no per-user font directory — an app can only see what the ROM installs,
      // plus whatever it bundles itself. `/product` and `/system_ext` are the
      // newer (Android 10+) homes for OEM-added families; the rest are legacy
      // paths kept around by most vendors.
      return [
        '/system/fonts/',
        '/system/font/',
        '/data/fonts/',
        '/product/fonts/',
        '/system_ext/fonts/',
      ];
    }

    if (Platform.isMacOS) {
      return [
        '/System/Library/Fonts/',
        '/Library/Fonts/',
        if (_homeDirectory case final home?) '$home/Library/Fonts/',
      ];
    }

    if (Platform.isLinux) {
      return [
        '/usr/share/fonts/',
        '/usr/local/share/fonts/',
        if (_homeDirectory case final home?) ...[
          '$home/.fonts/',
          '$home/.local/share/fonts/',
        ],
      ];
    }

    return [];
  }

  /// The current user's home directory, or `null` where the platform doesn't
  /// expose one (Android, or a sandboxed process with a stripped environment).
  String? get _homeDirectory =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  /// Returns a list of absolute file paths for every `.ttf` and `.otf` font
  /// found in the system font directories.
  ///
  /// Results are lazily computed and cached on first call.
  List<String> getFontPaths() {
    if (_fontPaths.isEmpty) {
      final paths = _fontDirectories;
      final List<FileSystemEntity> fontFilePaths = [];

      for (final path in paths) {
        final directory = Directory(path);
        try {
          if (!directory.existsSync()) {
            continue;
          }
          // Recursive because only Windows and Android keep their fonts in a
          // flat directory — macOS and Linux both nest families in
          // subdirectories, so a shallow listing finds almost nothing there.
          fontFilePaths.addAll(directory.listSync(recursive: true));
        } on FileSystemException {
          // A directory that exists but can't be read: several of the Android
          // system font paths are listed by the ROM yet unreadable from an app
          // sandbox. Skip it rather than taking down the caller.
          continue;
        }
      }

      _fontPaths.addAll(
        fontFilePaths
            .where(
              (element) =>
                  element.path.endsWith('.ttf') ||
                  element.path.endsWith('.otf'),
            )
            .map((e) => e.path)
            .toList(),
      );
    }
    return _fontPaths;
  }

  /// Returns a map of `{fontName: filePath}` for all discovered fonts.
  ///
  /// The font name is derived from the file's basename (without extension).
  Map<String, String> getFontMap() {
    if (_fontMap.isEmpty) {
      _fontMap.addAll(
        Map.fromEntries(
          getFontPaths().map(
            (e) => MapEntry(CMD.fs.basenameWithoutExtension(e), e),
          ),
        ),
      );
    }
    return _fontMap;
  }

  /// Returns a simple list of all discovered font names (no paths).
  List<String> getFontList() {
    return getFontMap().keys.toList();
  }

  /// Adds a single font file at [path] (must end with `.ttf` or `.otf`) to the
  /// font map.
  ///
  /// Returns the font name on success, or `null` if the path is invalid, the
  /// file doesn't exist, or a font with the same name is already known.
  String? addFontFile(String path) {
    if (!path.endsWith('.ttf') && !path.endsWith('.otf')) {
      return null;
    }

    if (!File(path).existsSync()) {
      return null;
    }

    final name = CMD.fs.basenameWithoutExtension(path);
    if (getFontMap().containsKey(name)) {
      return null;
    }

    _fontMap[name] = path;
    return name;
  }

  /// Scans an additional directory for `.ttf` and `.otf` files and adds them
  /// to the font map.
  ///
  /// Does nothing if the directory doesn't exist.
  void addAdditionalFontDirectory(String path) {
    final directory = Directory(path);

    final List<FileSystemEntity> entries;
    try {
      if (!directory.existsSync()) {
        return;
      }
      entries = directory.listSync();
    } on FileSystemException {
      return;
    }

    for (final FileSystemEntity e in entries) {
      if (!e.path.endsWith('.ttf') && !e.path.endsWith('.otf')) {
        continue;
      }
      _fontMap[CMD.fs.basenameWithoutExtension(e.path)] = e.path;
    }
  }

  /// Clears the cached font map and path list, forcing a fresh scan on the
  /// next call to [getFontPaths] or [getFontMap].
  void rescan() {
    _fontMap.clear();
    _fontPaths.clear();
  }
}
