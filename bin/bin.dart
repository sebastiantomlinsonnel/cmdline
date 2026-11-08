import 'package:cmdline/cmdline.dart';

void main() {
  final Moment time = Moment.now();
  final custom = TimeFormat.fromString('$Do of $MMM $yyyy').format(time);
  final worded = TimeFormat.worded.format(time);
  final wordedAsString = TimeFormat.fromString(
    'The $Do of $mmmm $yyyy at $hh:$mm:$ss',
  ).format(time);

  trace("custom : $custom ");
  trace("worded : $worded ");
  trace("wordedAsString : $wordedAsString ");
}
