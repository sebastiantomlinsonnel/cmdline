import 'dart:math' as math;

import 'package:cmdline/cmdline.dart';

/// Helpful extensions on nullable [double] values.
///
/// These make it painless to work with doubles that might be `null` — you
/// get safe defaults, range checks, and quick conversions without
/// scattering null-checks throughout your code.
///
/// ```dart
/// double? maybeValue;
/// print(maybeValue.validate()); // 0.0 (safe default)
/// ```
extension Double on double? {
  /// Returns this value if non-null, otherwise returns [value] (defaults to `0.0`).
  ///
  /// Handy as a null-safe fallback so you don't have to write `?? 0.0`
  /// everywhere.
  double validate({double value = 0.0}) => this ?? value;

  /// Returns `true` if this value falls between [first] and [second]
  /// (inclusive), regardless of which argument is larger.
  ///
  /// ```dart
  /// 100.0.isBetween(50.0, 150.0); // true
  /// 100.0.isBetween(150.0, 50.0); // true  (order doesn't matter)
  /// 100.0.isBetween(100.0, 100.0); // true (inclusive)
  /// ```
  bool isBetween(num first, num second) {
    final lower = math.min(first, second);
    final upper = math.max(first, second);
    return validate() >= lower && validate() <= upper;
  }

  /// Returns the absolute (positive) version of this value.
  ///
  /// If the value is `null`, returns `0.0`. If it's already positive,
  /// returns it as-is. If negative, flips the sign.
  double get positive {
    if (this != null) {
      if (isPositive) {
        return this ?? 0.0;
      } else {
        return (this! * -1);
      }
    } else {
      return 0.0;
    }
  }
}
