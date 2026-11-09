import 'package:cmdline/cmdline.dart';
import 'package:test/test.dart';

void main() {
  test('controlCodeRegExp matches cursor codes but not style codes', () {
    expect(controlCodeRegExp.hasMatch('\x1B[2K'), isTrue);
    expect(controlCodeRegExp.hasMatch('\x1B[31m'), isFalse);
  });
}
