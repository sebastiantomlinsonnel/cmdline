const String _alphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@%^\$&*()-_=[]{}|;:,.<>?~`\'"\\ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿЀЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя#';

/// Converts integers between numeral bases — from binary (base-2) all the
/// way up to base-256.
///
/// Under the hood, the conversion works by treating each base as a custom
/// alphabet. The [_alphabet] string defines 256+ unique symbols (digits, letters,
/// punctuation, Greek, and Cyrillic characters) and the algorithm maps
/// between source and destination alphabets using long division.
///
/// ## Common Conversions
///
/// ```dart
/// Radix.hex(255);         // 'FF'
/// Radix.bin(42);          // '101010'
/// Radix.oct(8);           // '10'
/// Radix.base(100, Base.b36); // base-36 representation
/// ```
///
/// ## Colour Helpers
///
/// [Radix] also includes a few helpers for clamping values into the 0-255
/// colour range:
///
/// ```dart
/// Radix.colourValue(128.7);            // 129
/// Radix.fractionToColourValue(0.5);    // 128
/// Radix.percentToColourValue(50.0);    // 128
/// ```
class Radix {
  String _value;
  int _base;

  /// Build a basic Radix instance
  Radix(this._value, this._base);

  set value(String value) {
    _value = value;
  }

  set base(int value) {
    _base = value;
  }

  /// Get the value of this radix as a decimal (0123456789)
  int get decimal => int.parse(Radix.getDecimal(_value, _base));

  /// Get the value of this radix as a base 256
  String get b256 => Radix.baseN(_value, _base, 256);

  /// Add one radix to another
  Radix add(Radix other) {
    final int dec = decimal + other.decimal;
    value = Radix.baseN(dec, 10, _base);
    return this;
  }

  /// Convert between bases
  static String baseN(dynamic data, int currentRadix, int toRadix) =>
      _crypt(data: data, from: _alpha(currentRadix), to: _alpha(toRadix));

  /// Converts an integer [data] to its string representation in the given
  /// [radix] base.
  ///
  /// ```dart
  /// Radix.base(255, Base.hexadecimal); // 'FF'
  /// Radix.base(42, Base.binary);       // '101010'
  /// ```
  static String getBase(int data, int radix) {
    radix = radix.clamp(0, 256);
    return _crypt(data: data, from: _alpha(), to: _alpha(radix));
  }

  /// Converts a string [data] from [currentRadix] back to its decimal
  /// (base-10) string representation.
  static String getDecimal(String data, int currentRadix) =>
      _crypt(data: data, from: _alpha(currentRadix), to: _alpha());

  /// Shorthand for hexadecimal (base-16) conversion, uppercase.
  static String hex(int data) => getBase(data, 16).toUpperCase();

  /// Clamps [data] to the 0-255 range and rounds to the nearest integer.
  ///
  /// Useful for ensuring a raw double stays within valid RGB bounds.
  static int colourValue(double data) {
    return data.clamp(0, 255).round();
  }

  /// Converts a 0.0-1.0 fraction to a 0-255 colour value.
  static int fractionToColourValue(double data) {
    return (data.clamp(0.0, 1.0) * 255).round();
  }

  /// Converts a 0-100 percentage to a 0-255 colour value.
  static int percentToColourValue(double data) {
    return ((data.clamp(0.0, 100.0) / 100) * 255).round();
  }

  static String _alpha([int a = 10]) => _alphabet.substring(0, a.clamp(0, 256));

  static String _crypt({
    dynamic data,
    required String from,
    required String to,
  }) {
    final source = data.toString();
    final int sourceBase = from.length;
    final int destinationBase = to.length;
    final Map<int, int> numberMap = {};
    int divide = 0;
    int newLength = 0;
    int length = source.length;
    String result = '';

    for (int i = 0; i < length; i++) {
      final index = from.indexOf(source[i]);
      if (index == -1) {
        throw FormatException(
          'Source "$source" contains character '
          '"${source[i]}" which is outside of the defined source alphabet '
          '"$from"',
        );
      }
      numberMap[i] = index;
    }

    do {
      divide = 0;
      newLength = 0;
      for (int i = 0; i < length; i++) {
        divide = divide * sourceBase + (numberMap[i] as int);
        if (divide >= destinationBase) {
          numberMap[newLength++] = divide ~/ destinationBase;
          divide = divide % destinationBase;
        } else if (newLength > 0) {
          numberMap[newLength++] = 0;
        }
      }
      length = newLength;
      result = to[divide] + result;
    } while (newLength != 0);
    return result;
  }
}
