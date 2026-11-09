// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// Pick a colour from a grid of hues and shades.
///
/// Left and right change the hue, up and down the shade; the bottom row is
/// greys. Typing `#` starts a hex code, like `#ff8800`. Gives back an
/// [AnsiColourRgb].
///
/// {@category cli}
class ColourPrompt extends PromptView<AnsiColourRgb> {
  static const int _hues = 18;
  static const List<double> _lightness = [0.85, 0.7, 0.55, 0.4, 0.25];
  static const int _degrees = 360;
  static const int _hexLength = 6;

  /// The colour picked at the start, and the answer when unattended.
  final AnsiColourRgb? start;

  int _hue = 0;
  int _shade = 2;
  String? _hex;

  /// Creates a colour picker asking [question].
  ColourPrompt(super.question, {this.start}) {
    final colour = start;
    if (colour != null) _hex = _toHex(colour).substring(1);
  }

  int get _rows => _lightness.length + 1;

  /// The colour in the grid at [hue], [shade].
  AnsiColourRgb _at(int hue, int shade) {
    if (shade == _lightness.length) {
      final level = (255 * hue / (_hues - 1)).round();

      return AnsiColourRgb(level, level, level);
    }

    return _fromHsl(hue * _degrees / _hues, 0.75, _lightness[shade]);
  }

  /// Converts hue (0-360), saturation and lightness (0-1) to RGB.
  static AnsiColourRgb _fromHsl(double hue, double saturation, double lightness) {
    final chroma = (1 - (2 * lightness - 1).abs()) * saturation;
    final section = hue / 60;
    final x = chroma * (1 - (section % 2 - 1).abs());
    final (r, g, b) = switch (section.floor()) {
      0 => (chroma, x, 0.0),
      1 => (x, chroma, 0.0),
      2 => (0.0, chroma, x),
      3 => (0.0, x, chroma),
      4 => (x, 0.0, chroma),
      _ => (chroma, 0.0, x),
    };
    final m = lightness - chroma / 2;
    int channel(double value) => ((value + m) * 255).round().clamp(0, 255);

    return AnsiColourRgb(channel(r), channel(g), channel(b));
  }

  static String _toHex(AnsiColourRgb colour) =>
      '#${[colour.red, colour.green, colour.blue].map((c) => c.toRadixString(16).padLeft(2, '0')).join()}';

  AnsiColourRgb? get _typed {
    final hex = _hex;
    if (hex == null || hex.length != _hexLength) return null;
    final value = int.tryParse(hex, radix: 16);

    return value == null ? null : AnsiColourRgb.hex(value);
  }

  AnsiColourRgb get _current => _typed ?? _at(_hue, _shade);

  @override
  String inline() {
    final hex = _hex;
    final swatch = '    '.background(_current);

    return hex == null ? '$swatch ${_toHex(_current)}' : '$swatch #$hex';
  }

  @override
  int? get inlineCursor => _hex == null ? null : 6 + _hex!.length;

  @override
  List<String> body() => [
    for (var shade = 0; shade < _rows; shade++)
      '  ${[
        for (var hue = 0; hue < _hues; hue++)
          hue == _hue && shade == _shade && _hex == null
              ? '◆ '.bold.foreground(shade < 2 ? const AnsiColour(0) : const AnsiColour(15)).background(_at(hue, shade))
              : '  '.background(_at(hue, shade)),
      ].join()}',
  ];

  @override
  List<KeyHint> get keys => const [
    ('←→', 'hue'),
    ('↑↓', 'shade'),
    ('#', 'hex'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final hex = _hex;
    if (hex != null) {
      if (press.key == Key.enter) {
        if (_typed != null) return KeyResult.done;
        error = 'Type six hex digits, like ff8800';

        return KeyResult.handled;
      }
      if (press.key == Key.backspace) {
        _hex = hex.isEmpty ? null : hex.substring(0, hex.length - 1);

        return KeyResult.handled;
      }
      if (press.key == Key.char && RegExp('^[0-9a-fA-F]\$').hasMatch(press.char)) {
        if (hex.length < _hexLength) _hex = '$hex${press.char.toLowerCase()}';

        return KeyResult.handled;
      }
      if (press.key == Key.escape) {
        _hex = null;

        return KeyResult.handled;
      }
    }
    switch (press.key) {
      case Key.left:
        _hue = (_hue - 1) % _hues;
      case Key.right:
        _hue = (_hue + 1) % _hues;
      case Key.up:
        _shade = (_shade - 1).clamp(0, _rows - 1);
      case Key.down:
        _shade = (_shade + 1).clamp(0, _rows - 1);
      case Key.char when press.char == '#':
        _hex = '';

        return KeyResult.handled;
      case Key.enter:
        return KeyResult.done;
      default:
        return KeyResult.ignored;
    }
    _hex = null;

    return KeyResult.handled;
  }

  @override
  AnsiColourRgb get result => _current;

  @override
  String describe(AnsiColourRgb value) =>
      '${'  '.background(value)} ${_toHex(value)}';

  @override
  String get fallbackHint => start == null ? '(hex, like #ff8800)' : '(${_toHex(start!)})';

  @override
  ({AnsiColourRgb? value, String? problem}) parse(String typed) {
    final text = typed.isEmpty && start != null ? _toHex(start!) : typed;
    final hex = text.trim().replaceFirst('#', '');
    final value = hex.length == _hexLength ? int.tryParse(hex, radix: 16) : null;

    return value == null
        ? (value: null, problem: 'Type a hex colour, like #ff8800')
        : (value: AnsiColourRgb.hex(value), problem: null);
  }

  @override
  AnsiColourRgb? get unattended => start;
}
