import '../../../../cmdline.dart';

/// Editable text with a cursor, for text boxes.
///
/// Works on user-perceived characters (graphemes), so an emoji or an accented
/// letter is one step of the cursor. Understands the usual editing keys:
/// arrows, Home/End, Backspace/Delete, Ctrl+arrows to jump words, Ctrl+U to
/// clear before the cursor, Ctrl+K after it and Ctrl+W the word before it.
///
/// {@category cli}
class TextBuffer {
  List<String> _chars;
  int _cursor;

  /// Creates a buffer holding [text], with the cursor at the end.
  TextBuffer([String text = ''])
    : _chars = graphemes(text).toList(),
      _cursor = graphemes(text).length;

  /// The text in the buffer.
  String get text => _chars.join();

  set text(String value) {
    _chars = graphemes(value).toList();
    _cursor = _chars.length;
  }

  /// Whether the buffer is empty.
  bool get isEmpty => _chars.isEmpty;

  /// Where the cursor is, in characters from the start.
  int get cursor => _cursor;

  /// The text before the cursor.
  String get beforeCursor => _chars.sublist(0, _cursor).join();

  /// The text from the cursor on.
  String get afterCursor => _chars.sublist(_cursor).join();

  /// Puts [value] in at the cursor.
  void insert(String value) {
    final added = graphemes(value).toList();
    _chars.insertAll(_cursor, added);
    _cursor += added.length;
  }

  /// Empties the buffer.
  void clear() {
    _chars = [];
    _cursor = 0;
  }

  /// Changes the text for an editing key. Gives back true if [press] was
  /// used, so the caller knows to redraw.
  bool handle(KeyPress press) {
    final text = press.text;
    if (text.isNotEmpty) {
      insert(text);

      return true;
    }
    switch (press.key) {
      case Key.backspace when _cursor > 0:
        _chars.removeAt(--_cursor);
      case Key.delete when _cursor < _chars.length:
        _chars.removeAt(_cursor);
      case Key.left when press.ctrl || press.alt:
        _cursor = _wordStart();
      case Key.right when press.ctrl || press.alt:
        _cursor = _wordEnd();
      case Key.left when _cursor > 0:
        _cursor--;
      case Key.right when _cursor < _chars.length:
        _cursor++;
      case Key.home:
        _cursor = 0;
      case Key.end:
        _cursor = _chars.length;
      case Key.ctrl when press.char == 'a':
        _cursor = 0;
      case Key.ctrl when press.char == 'e':
        _cursor = _chars.length;
      case Key.ctrl when press.char == 'u':
        _chars.removeRange(0, _cursor);
        _cursor = 0;
      case Key.ctrl when press.char == 'k':
        _chars.removeRange(_cursor, _chars.length);
      case Key.ctrl when press.char == 'w':
        final start = _wordStart();
        _chars.removeRange(start, _cursor);
        _cursor = start;
      default:
        return false;
    }

    return true;
  }

  /// Where the word before the cursor starts.
  int _wordStart() {
    var at = _cursor;
    while (at > 0 && _chars[at - 1] == ' ') {
      at--;
    }
    while (at > 0 && _chars[at - 1] != ' ') {
      at--;
    }

    return at;
  }

  /// Where the word after the cursor ends.
  int _wordEnd() {
    var at = _cursor;
    while (at < _chars.length && _chars[at] == ' ') {
      at++;
    }
    while (at < _chars.length && _chars[at] != ' ') {
      at++;
    }

    return at;
  }
}
