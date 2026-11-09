// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:convert';

import 'terminal.dart';

/// The kinds of key a prompt can react to.
///
/// {@category cli}
enum Key {
  /// Enter or Return.
  enter,

  /// Esc. A lone Esc is only seen once the next key arrives, so prompts also
  /// take a double Esc.
  escape,

  /// Tab.
  tab,

  /// Shift+Tab.
  backTab,

  /// Backspace.
  backspace,

  /// Delete (forward delete).
  delete,

  /// Insert.
  insert,

  /// The up arrow.
  up,

  /// The down arrow.
  down,

  /// The left arrow.
  left,

  /// The right arrow.
  right,

  /// Home.
  home,

  /// End.
  end,

  /// Page Up.
  pageUp,

  /// Page Down.
  pageDown,

  /// The space bar.
  space,

  /// A typed character, in [KeyPress.char].
  char,

  /// Ctrl and a letter, in [KeyPress.char] (lower case). Not Ctrl+C.
  ctrl,

  /// Ctrl+C.
  interrupt,

  /// The input has ended (the pipe or file ran out).
  endOfInput,

  /// A key with no meaning here, like F5.
  unknown,
}

/// One key press: what it was, plus any Ctrl, Alt or Shift held with it.
///
/// {@category cli}
class KeyPress {
  /// Which key it was.
  final Key key;

  /// The typed character for [Key.char], or the letter for [Key.ctrl].
  final String char;

  /// Whether Ctrl was held (always true for [Key.ctrl]).
  final bool ctrl;

  /// Whether Alt was held.
  final bool alt;

  /// Whether Shift was held.
  final bool shift;

  /// Creates a key press.
  const KeyPress(
    this.key, {
    this.char = '',
    this.ctrl = false,
    this.alt = false,
    this.shift = false,
  });

  /// A typed character, like `KeyPress.of('a')`.
  const KeyPress.of(this.char)
    : key = Key.char,
      ctrl = false,
      alt = false,
      shift = false;

  /// Ctrl and [letter], like `KeyPress.control('d')`.
  const KeyPress.control(String letter)
    : key = Key.ctrl,
      char = letter,
      ctrl = true,
      alt = false,
      shift = false;

  /// The text this key types, or an empty string if it types nothing.
  String get text => switch (key) {
    Key.char when !ctrl && !alt => char,
    Key.space => ' ',
    _ => '',
  };

  /// Whether this is the typed character [character].
  bool isChar(String character) => key == Key.char && char == character;

  /// Whether this is Ctrl and [letter].
  bool isCtrl(String letter) => key == Key.ctrl && char == letter;

  @override
  String toString() {
    final mods = [if (ctrl) 'ctrl', if (alt) 'alt', if (shift) 'shift'];
    final name = char.isEmpty ? key.name : '${key.name}($char)';

    return mods.isEmpty ? name : '${mods.join('+')}+$name';
  }
}

/// Byte values used by [KeyReader].
abstract final class _Byte {
  static const int ctrlC = 3;
  static const int backspaceCtrlH = 8;
  static const int tab = 9;
  static const int lineFeed = 10;
  static const int carriageReturn = 13;
  static const int ctrlZ = 26;
  static const int escape = 27;
  static const int space = 32;
  static const int delete = 127;
  static const int openBracket = 0x5B; // [
  static const int letterO = 0x4F; // O
  static const int tilde = 0x7E; // ~
  static const int asciiEnd = 0x80;
  static const int windowsPrefix = 0xE0;
  static const int ctrlLetterOffset = 96;
  static const int finalFirst = 0x40;
  static const int finalLast = 0x7E;
}

/// Reads key presses one at a time from a [Terminal].
///
/// Understands the escape sequences sent by Windows Terminal, conhost,
/// xterm-like terminals and older Windows consoles, including Ctrl, Alt and
/// Shift held with arrows and other keys. Blocks until a key arrives.
///
/// {@category cli}
class KeyReader {
  final Terminal _terminal;
  final List<int> _pending = [];

  /// Creates a reader for [terminal] (the current one when left out).
  KeyReader([Terminal? terminal]) : _terminal = terminal ?? Terminal.current;

  /// Waits for the next key press and gives it back.
  KeyPress read() {
    final byte = _next();

    return switch (byte) {
      -1 => const KeyPress(Key.endOfInput),
      _Byte.ctrlC => const KeyPress(Key.interrupt, ctrl: true),
      _Byte.lineFeed || _Byte.carriageReturn => const KeyPress(Key.enter),
      _Byte.tab => const KeyPress(Key.tab),
      _Byte.backspaceCtrlH || _Byte.delete => const KeyPress(Key.backspace),
      _Byte.space => const KeyPress(Key.space),
      _Byte.escape => _escape(),
      0 => _windowsKey(_next()),
      _Byte.windowsPrefix => _windowsOrUtf8(),
      final b when b >= 1 && b <= _Byte.ctrlZ =>
        KeyPress.control(String.fromCharCode(b + _Byte.ctrlLetterOffset)),
      _ => _character(byte),
    };
  }

  /// The next byte, from the replay list first.
  int _next() => _pending.isNotEmpty ? _pending.removeAt(0) : _terminal.readByte();

  /// Works out what follows an Esc byte.
  KeyPress _escape() {
    final second = _next();
    if (second == _Byte.openBracket) return _csi();
    if (second == _Byte.letterO) return _ss3(_next());
    // A lone Esc: give back the byte that came after for the next read.
    if (second != _Byte.escape && second != -1) _pending.add(second);

    return const KeyPress(Key.escape);
  }

  /// Reads an `ESC [ params final` sequence.
  KeyPress _csi() {
    final params = StringBuffer();
    var last = _next();
    while (last != -1 && (last < _Byte.finalFirst || last > _Byte.finalLast)) {
      params.writeCharCode(last);
      last = _next();
    }
    final parts = params.toString().split(';');
    final modifier = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
    final key = last == _Byte.tilde
        ? _tildeKey(int.tryParse(parts.first) ?? 0)
        : _letterKey(String.fromCharCode(last));
    if (key == Key.backTab) return const KeyPress(Key.backTab, shift: true);

    // xterm modifiers: 1 + shift(1) + alt(2) + ctrl(4).
    final bits = modifier - 1;

    return KeyPress(
      key,
      shift: bits & 1 != 0,
      alt: bits & 2 != 0,
      ctrl: bits & 4 != 0,
    );
  }

  /// Reads the letter after `ESC O`.
  KeyPress _ss3(int byte) => KeyPress(_letterKey(String.fromCharCode(byte)));

  /// The key for a sequence ending in a letter, like `A` for up.
  static Key _letterKey(String letter) => switch (letter) {
    'A' => Key.up,
    'B' => Key.down,
    'C' => Key.right,
    'D' => Key.left,
    'H' => Key.home,
    'F' => Key.end,
    'Z' => Key.backTab,
    _ => Key.unknown,
  };

  /// The key for a sequence ending in `~`, like `3~` for Delete.
  static Key _tildeKey(int code) => switch (code) {
    1 || 7 => Key.home,
    2 => Key.insert,
    3 => Key.delete,
    4 || 8 => Key.end,
    5 => Key.pageUp,
    6 => Key.pageDown,
    _ => Key.unknown,
  };

  /// Older Windows consoles send 0x00 or 0xE0 and then a scan code.
  static KeyPress _windowsKey(int code) => KeyPress(switch (code) {
    0x48 => Key.up,
    0x50 => Key.down,
    0x4B => Key.left,
    0x4D => Key.right,
    0x47 => Key.home,
    0x4F => Key.end,
    0x49 => Key.pageUp,
    0x51 => Key.pageDown,
    0x52 => Key.insert,
    0x53 => Key.delete,
    _ => Key.unknown,
  });

  /// 0xE0 starts a Windows scan code or a three byte UTF-8 character.
  KeyPress _windowsOrUtf8() {
    final next = _next();
    if (next < _Byte.asciiEnd) return _windowsKey(next);
    _pending.insert(0, next);

    return _character(_Byte.windowsPrefix);
  }

  /// Decodes a typed character starting with [first], reading any more
  /// UTF-8 bytes it needs.
  KeyPress _character(int first) {
    final length = switch (first) {
      < 0x80 => 1,
      >= 0xC2 && <= 0xDF => 2,
      >= 0xE0 && <= 0xEF => 3,
      >= 0xF0 && <= 0xF4 => 4,
      _ => 0,
    };
    if (length == 0) return const KeyPress(Key.unknown);
    final bytes = [first];
    for (var i = 1; i < length; i++) {
      final next = _next();
      if (next < 0x80 || next > 0xBF) {
        if (next != -1) _pending.add(next);

        return const KeyPress(Key.unknown);
      }
      bytes.add(next);
    }

    return KeyPress.of(utf8.decode(bytes, allowMalformed: true));
  }
}
