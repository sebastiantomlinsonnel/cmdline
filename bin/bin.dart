import 'package:cmdline/cmdline.dart';

void main() {
  final Moment time = Moment.now();
  final custom = TimeFormat.fromString('$Do of $MMM $yyyy').format(time);
  final worded = TimeFormat.worded.format(time);

  trace("custom : $custom ");
  trace("worded : $worded ");
}
