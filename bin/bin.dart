import 'package:cmdline/cmdline.dart';

void main() {
  final Moment time = Moment.now();

  trace(TimeFormat.worded.format(time), tag: 'worded');
  trace(TimeFormat.time24.format(time), tag: 'time24');
  trace(TimeFormat.time12.format(time), tag: 'time12');
  trace(TimeFormat.isoDate.format(time), tag: 'isoDate');
  trace(TimeFormat.isoDateTime.format(time), tag: 'isoDateTime');
  trace(TimeFormat.dateUk.format(time), tag: 'dateUk');
  trace(TimeFormat.dateUs.format(time), tag: 'dateUs');
  trace(TimeFormat.shortDate.format(time), tag: 'shortDate');
  trace(TimeFormat.longDate.format(time), tag: 'longDate');
  trace(TimeFormat.fullDate.format(time), tag: 'fullDate');
  trace(TimeFormat.fullDateUs.format(time), tag: 'fullDateUs');
  trace(TimeFormat.dayMonth.format(time), tag: 'dayMonth');
  trace(TimeFormat.monthYear.format(time), tag: 'monthYear');
  trace(TimeFormat.spokenDate.format(time), tag: 'spokenDate');
  trace(TimeFormat.shortTime24.format(time), tag: 'shortTime24');
  trace(TimeFormat.shortTime12.format(time), tag: 'shortTime12');
  trace(TimeFormat.dateTime.format(time), tag: 'dateTime');
  trace(TimeFormat.log.format(time), tag: 'log');
  trace(TimeFormat.fileSafe.format(time), tag: 'fileSafe');
  trace(TimeFormat.friendly.format(time), tag: 'friendly');
}
