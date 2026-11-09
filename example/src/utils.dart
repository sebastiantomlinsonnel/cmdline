import 'package:cmdline/cmdline.dart';

import 'section.dart';

/// Demos for the string, number and list helpers, shown as call/result tables.
class UtilsDemo {
  const UtilsDemo._();

  /// Runs every utility demo in turn.
  static Future<void> all() async {
    await section('Strings', strings);
    await section('Numbers and lists', numbers);
    await section('Bases', radix);
  }

  /// Shows the `Strings` helpers and the String extension.
  static void strings() {
    heading('Changing case');
    showCalls([
      [
        'Strings.toCamelCase("hello_big_world")',
        Strings.toCamelCase('hello_big_world'),
      ],
      [
        'Strings.toCamelCase(..., lower: true)',
        Strings.toCamelCase('hello_big_world', lower: true),
      ],
      [
        'Strings.toSnakeCase("helloBigWorld")',
        Strings.toSnakeCase('helloBigWorld'),
      ],
      [
        'Strings.toCapitalised("hello world")',
        Strings.toCapitalised('hello world'),
      ],
      [
        'Strings.toProperCase("hello big world")',
        Strings.toProperCase('hello big world'),
      ],
      ['Strings.reverse("stressed")', Strings.reverse('stressed')],
    ]);

    heading('Cutting and joining');
    showCalls([
      [
        'Strings.abbreviate("A long sentence here", 12)',
        Strings.abbreviate('A long sentence here', 12),
      ],
      [
        'Strings.hidePart("4111222233334444", start: 4, end: 12)',
        Strings.hidePart('4111222233334444', start: 4, end: 12),
      ],
      ['Strings.left("cmdline", 3)', Strings.left('cmdline', 3)],
      ['Strings.right("cmdline", 4)', Strings.right('cmdline', 4)],
      [
        'Strings.within("max(a, b)", "(", ")")',
        Strings.within('max(a, b)', '(', ')'),
      ],
      ['Strings.upTo("key=value", "=")', Strings.upTo('key=value', '=')],
      [
        'Strings.conjuctionJoin(["red", "green", "blue"])',
        Strings.conjuctionJoin(['red', 'green', 'blue']),
      ],
      [
        'Strings.join(["a", "", "b"], separator: "-", excludeEmpty: true)',
        Strings.join(['a', '', 'b'], separator: '-', excludeEmpty: true),
      ],
    ]);

    heading('Checks and null safety');
    showCalls([
      ['Strings.isNumeric("3.14")', Strings.isNumeric('3.14')],
      ['Strings.isDigits("2026")', Strings.isDigits('2026')],
      ['Strings.isAscii("café")', Strings.isAscii('café')],
      ['Strings.isUpperCase("LOUD")', Strings.isUpperCase('LOUD')],
      [
        'Strings.startsWithUpperCase("Dart")',
        Strings.startsWithUpperCase('Dart'),
      ],
      ['Strings.isBlank("   ")', Strings.isBlank('   ')],
      ['Strings.orElse(null, "fallback")', Strings.orElse(null, 'fallback')],
      [
        'Strings.equalsIgnoreCase("Dart", "DART")',
        Strings.equalsIgnoreCase('Dart', 'DART'),
      ],
      ['Strings.length(null)', Strings.length(null)],
      ['Strings.toEscape("tab\\there")', Strings.toEscape('tab\there')],
    ]);

    heading('String extension');
    const sentence = 'The quick brown fox';
    showCalls([
      ['"$sentence".words', sentence.words],
      ['"a\\nb\\nc".lines', 'a\nb\nc'.lines],
      ['"$sentence".getChar(4)', sentence.getChar(4)],
      ['"12345".isDigits()', '12345'.isDigits()],
      ['"hello".isLowerCase()', 'hello'.isLowerCase()],
    ]);

    heading('Graphemes: what you see, not code units');
    const emoji = 'hi 👋🏽 🇿🇦';
    showCalls([
      ['emoji.length', emoji.length],
      ['emoji.characters.length (code units)', emoji.characters.length],
      ['graphemes(emoji).length', graphemes(emoji).length],
      ['graphemes(emoji)', graphemes(emoji).toList()],
    ]);
  }

  /// Shows the num, int, double and list extensions.
  static void numbers() {
    const int? missing = null;
    heading('Numbers');
    showCalls([
      ['missing.validate(value: 7)', missing.validate(value: 7)],
      ['15.isBetween(10, 20)', 15.isBetween(10, 20)],
      ['200.isSuccessful()', 200.isSuccessful()],
      ['3.14159.roundToPrecision(2)', 3.14159.roundToPrecision(2)],
      ['3.14159.toDoubleDigits(3)', 3.14159.toDoubleDigits(3)],
      ['25.percentageOf(200)', 25.percentageOf(200)],
      ['(-4.5).positive', (-4.5).positive],
      ['(-3).isNegative', (-3).isNegative],
      ['4.0.isInteger', 4.0.isInteger],
    ]);

    heading('Durations and dates');
    showCalls([
      ['90.seconds', 90.seconds],
      ['3.hours + 15.minutes', 3.hours + 15.minutes],
      ['2.days', 2.days],
      ['22.toMonthDaySuffix()', 22.toMonthDaySuffix()],
      ['11.toMonthName()', 11.toMonthName()],
      ['11.toMonthName(isHalfName: true)', 11.toMonthName(isHalfName: true)],
      ['4.toWeekDay()', 4.toWeekDay()],
    ]);

    heading('Lists');
    const prices = [4.5, 12.0, 7.25];
    const List<int>? none = null;
    showCalls([
      ['prices', prices],
      ['prices.sumByDouble((p) => p)', prices.sumByDouble((price) => price)],
      ['prices.averageBy((p) => p)', prices.averageBy((price) => price)],
      [
        '["a", "bb", "ccc"].sumBy((s) => s.length)',
        ['a', 'bb', 'ccc'].sumBy((text) => text.length),
      ],
      ['none.validate()', none.validate()],
    ]);
    [
      'first',
      'second',
      'third',
    ].forEachIndexed((item, index) => log('forEachIndexed: $index = $item'));
  }

  /// Shows base conversion with the int extension and [Radix].
  static void radix() {
    const number = 2026;
    showCalls([
      ['$number.bin', number.bin],
      ['$number.oct', number.oct],
      ['$number.dec', number.dec],
      ['$number.hex', number.hex],
      ['$number.b256', number.b256],
      ['Radix.hex(255)', Radix.hex(255)],
      ['Radix.baseN("FF", 16, 2)', Radix.baseN('FF', 16, 2)],
      ['Radix("777", 8).decimal', Radix('777', 8).decimal],
      [
        'Radix("FF", 16).add(Radix("1", 10)).decimal',
        Radix('FF', 16).add(Radix('1', 10)).decimal,
      ],
      ['Radix.percentToColourValue(50)', Radix.percentToColourValue(50)],
    ]);
  }
}
