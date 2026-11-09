import 'dart:math' as math;

import '../../../../cmdline.dart';

/// Pick a day on a month calendar.
///
/// The arrows move by a day or a week, Page Up/Down by a month, Home/End to
/// the first and last day of the month, and `t` back to today. Days outside
/// [first] and [last] can't be picked. Gives back a [DateTime] at midnight.
///
/// {@category cli}
class DatePrompt extends PromptView<DateTime> {
  /// The earliest day allowed, if any.
  final DateTime? first;

  /// The latest day allowed, if any.
  final DateTime? last;

  /// The day picked at the start.
  final DateTime start;

  DateTime _day;

  /// Creates a calendar asking [question], starting on [start] (or today).
  DatePrompt(super.question, {DateTime? start, this.first, this.last})
    : start = _dateOnly(start ?? DateTime.now()),
      _day = _dateOnly(start ?? DateTime.now()) {
    _day = _limit(_day);
  }

  static DateTime _dateOnly(DateTime time) =>
      DateTime(time.year, time.month, time.day);

  static int _daysIn(int year, int month) => DateTime(year, month + 1, 0).day;

  bool _allowed(DateTime day) {
    final from = first;
    final to = last;

    return (from == null || !day.isBefore(_dateOnly(from))) &&
        (to == null || !day.isAfter(_dateOnly(to)));
  }

  DateTime _limit(DateTime day) {
    final from = first;
    final to = last;
    if (from != null && day.isBefore(_dateOnly(from))) return _dateOnly(from);
    if (to != null && day.isAfter(_dateOnly(to))) return _dateOnly(to);

    return day;
  }

  DateTime _addMonths(int months) {
    final target = DateTime(_day.year, _day.month + months);

    return DateTime(
      target.year,
      target.month,
      math.min(_day.day, _daysIn(target.year, target.month)),
    );
  }

  /// [day] as `2026-11-09`.
  static String iso(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  @override
  String inline() => muted(iso(_day));

  @override
  List<String> body() {
    final today = _dateOnly(DateTime.now());
    final title = '${_day.month.toMonthName()} ${_day.year}';
    const cellWidth = 3;
    const week = 7;
    final lines = <String>[
      '  ${title.bold.padWidth(week * cellWidth)}',
      '  ${[for (var d = 1; d <= week; d++) d.toWeekDay(isHalfName: true).substring(0, 2)].join(' ').foreground(theme.hint)}',
    ];
    final firstDay = DateTime(_day.year, _day.month);
    final offset = firstDay.weekday - 1;
    final days = _daysIn(_day.year, _day.month);
    var row = StringBuffer('  ${' ' * (offset * cellWidth)}');
    for (var date = 1; date <= days; date++) {
      final day = DateTime(_day.year, _day.month, date);
      var text = '$date'.padLeft(2);
      if (day == _day) {
        text = text.inverse.bold.foreground(theme.highlight);
      } else if (!_allowed(day)) {
        text = muted(text);
      } else if (day == today) {
        text = text.underline.foreground(theme.highlight);
      }
      row.write(text);
      if ((offset + date) % week == 0 || date == days) {
        lines.add(row.toString());
        row = StringBuffer('  ');
      } else {
        row.write(' ');
      }
    }

    return lines;
  }

  @override
  List<KeyHint> get keys => const [
    ('arrows', 'day/week'),
    ('pgup/pgdn', 'month'),
    ('t', 'today'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final moved = switch (press.key) {
      Key.left => _day.subtract(const Duration(days: 1)),
      Key.right => _day.add(const Duration(days: 1)),
      Key.up => _day.subtract(const Duration(days: 7)),
      Key.down => _day.add(const Duration(days: 7)),
      Key.pageUp => _addMonths(-1),
      Key.pageDown => _addMonths(1),
      Key.home => DateTime(_day.year, _day.month),
      Key.end => DateTime(
        _day.year,
        _day.month,
        _daysIn(_day.year, _day.month),
      ),
      Key.char when press.char == 't' => _dateOnly(DateTime.now()),
      _ => null,
    };
    if (moved != null) {
      // Day maths across a clock change can land on 23:00; snap to the date.
      _day = _limit(_dateOnly(moved.add(const Duration(hours: 12))));

      return KeyResult.handled;
    }
    if (press.key == Key.enter) return KeyResult.done;

    return KeyResult.ignored;
  }

  @override
  DateTime get result => _day;

  @override
  String describe(DateTime value) =>
      '${iso(value)} (${value.weekday.toWeekDay(isHalfName: true)})';

  @override
  String get fallbackHint => '(yyyy-mm-dd, ${iso(start)})';

  @override
  ({DateTime? value, String? problem}) parse(String typed) {
    if (typed.isEmpty) return (value: start, problem: null);
    final match = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$')
        .firstMatch(typed.trim());
    if (match == null)
      return (value: null, problem: 'Type a date like ${iso(start)}');
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final date = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || date < 1 || date > _daysIn(year, month)) {
      return (value: null, problem: 'That day doesn\'t exist');
    }
    final day = DateTime(year, month, date);
    if (!_allowed(day))
      return (value: null, problem: 'Pick a day in the allowed range');

    return (value: day, problem: null);
  }

  @override
  DateTime? get unattended => start;
}
