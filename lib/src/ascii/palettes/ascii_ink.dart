import 'package:cmdline/ascii.dart';

abstract class AsciiInk {
  const AsciiInk();

  String get parameters;

  String get fg => '${CSI}38;$parameters$SGR';

  String get bg => '${CSI}48;$parameters$SGR';

  String get underline => '${CSI}58;$parameters$SGR';

  AsciiColourRgb toRgb();

  AsciiColourRgb opacity(
    double amount, {
    AsciiInk over = const AsciiColourRgb(0, 0, 0),
  }) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0-1');

    final AsciiColourRgb front = toRgb();
    final AsciiColourRgb back = over.toRgb();
    int mix(int f, int b) => ((f * amount) + (b * (1 - amount))).round();

    return AsciiColourRgb(
      mix(front.red, back.red),
      mix(front.green, back.green),
      mix(front.blue, back.blue),
    );
  }
}
