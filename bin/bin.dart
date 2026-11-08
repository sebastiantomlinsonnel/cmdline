import 'package:cmdline/cmdline.dart';

void main() {
  final Moment time = Moment.now();

  trace('${TimeFormat.time12Hour.format(time)}', tag: '12 Hour');
  trace('${TimeFormat.time24Hour.format(time)}', tag: '24 Hour');
}
