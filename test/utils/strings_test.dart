import 'package:cmdline/cmdline.dart';
import 'package:test/test.dart';

void main() {
  group('graphemes', () {
    test('reverse keeps emoji sequences intact', () {
      expect(Strings.reverse('a👨‍👩‍👧b'), 'b👨‍👩‍👧a');
      expect(Strings.reverse('🇬🇧🇫🇷'), '🇫🇷🇬🇧');
      expect(Strings.reverse('aé'), 'éa');
    });

    test('hidePart counts user-perceived characters', () {
      expect(Strings.hidePart('👍🏽ab', start: 0, end: 1), '*ab');
      expect(Strings.hidePart('secret', start: 2), 'se****');
    });

    test('toCapitalised does not split surrogate pairs', () {
      expect(Strings.toCapitalised('hello'), 'Hello');
      expect(Strings.toCapitalised('😀x'), '😀x');
    });
  });

  test('isPrintable', () {
    expect(Strings.isPrintable('A'.codeUnitAt(0)), isTrue);
    expect(Strings.isPrintable('é'.runes.first), isTrue);
    expect(Strings.isPrintable(0x7), isFalse);
    expect(Strings.isPrintable(0xE000), isFalse);
    expect(Strings.isPrintable(0x2028), isFalse);
    expect(Strings.isPrintable(null), isFalse);
    expect(Strings.isPrintable(-1), isFalse);
    expect(Strings.isPrintable(0x110000), isFalse);
  });

  test('case checks', () {
    expect(Strings.isUpperCase('DART'), isTrue);
    expect(Strings.isUpperCase('CamelCase'), isFalse);
    expect(Strings.isUpperCase(''), isTrue);
    expect(Strings.isLowerCase('dart'), isTrue);
    expect(Strings.startsWithLowerCase('camelCase'), isTrue);
    expect(Strings.startsWithUpperCase('Dart'), isTrue);
    expect(Strings.startsWithUpperCase(''), isFalse);
  });

  test('case conversions', () {
    expect(Strings.toCamelCase('dart_vm'), 'DartVm');
    expect(Strings.toCamelCase('dart_vm', lower: true), 'dartVm');
    expect(Strings.toSnakeCase('DartVm'), 'dart_vm');
    expect(Strings.toProperCase('hELLO  wORLD'), 'Hello World');
  });

  test('escaping', () {
    expect(Strings.toEscape("a'\n"), r"a\'\n");
    expect(Strings.toEscape('\x01'), r'\u0001');
    expect(Strings.toPrintable("Hello 'world' \n"), r"Hello 'world' \n");
    expect(Strings.toUnicode(10), r'\u000a');
    expect(() => Strings.toUnicode(-1), throwsRangeError);
  });

  test('abbreviate', () {
    expect(Strings.abbreviate('Hello World', 6), 'Hel...');
    expect(Strings.abbreviate('Hi', 6), 'Hi');
    expect(Strings.abbreviate(null, 6), '');
  });

  test('left and right padding', () {
    expect(Strings.left('abc', 2), 'ab');
    expect(Strings.left('ab', 4, pad: Pad.left), '  ab');
    expect(Strings.left('ab', 4, pad: Pad.right), 'ab  ');
    expect(Strings.left('ab', 4), 'ab');
    expect(Strings.right('abc', 2), 'bc');
    expect(Strings.right(null, 2, pad: Pad.right), '  ');
  });

  test('null handling', () {
    expect(Strings.substring(null, 2, 3), ' ');
    expect(Strings.equals(null, null), isTrue);
    expect(Strings.equals('a', null), isFalse);
    expect(Strings.equalsIgnoreCase('ABC', 'abc'), isTrue);
    expect(Strings.compareTo(null, 'a'), -1);
    expect(Strings.compareTo(null, 'a', nullIsLessThan: false), 1);
    expect(Strings.compareTo(null, null), 0);
    expect(Strings.join([1, null, 2], separator: ','), '1,,2');
    expect(Strings.join(['a', ' ', null, 'b'], excludeEmpty: true), 'ab');
  });

  test('misc', () {
    expect(Strings.conjuctionJoin(['a', 'b', 'c']), 'a, b or c');
    expect(Strings.within('(a(b)c)', '(', ')'), 'a(b)c');
    expect(Strings.upTo('key=value', '='), 'key');
    expect(Strings.isNumeric('1.5'), isTrue);
    expect(Strings.isNumeric('NaN'), isFalse);
    expect(Strings.isDigits('123'), isTrue);
    expect(Strings.isAscii('abc'), isTrue);
    expect(Strings.isAscii('é'), isFalse);
  });
}
