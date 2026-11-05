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
extension Ba on int {
  /// Converts this integer to its **octal** (base-8) string representation.
  String get oct {
    return Radix.getBase(this, 8);
  }

  /// Converts this integer to its **binary** (base-2) string representation,
  /// in uppercase.
  String get bin {
    return Radix.getBase(this, 2).toUpperCase();
  }

  /// Converts this integer to its **hexadecimal** (base-16) string
  /// representation, in uppercase.
  ///
  /// ```dart
  /// 255.hex // 'FF'
  /// ```
  String get hex {
    return Radix.getBase(this, 16).toUpperCase();
  }

  /// Converts this integer to its **decimal** (base-10) string representation.
  String get dec {
    return Radix.getBase(this, 10);
  }

  /// Converts this integer to its **base-256** encoded string.
  ///
  /// Base-256 treats each byte as a single "digit," which is useful for
  /// compact binary encoding.
  String get b256 {
    return Radix.getBase(this, 256);
  }
}
