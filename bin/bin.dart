import 'package:cmdline/cmdline.dart';

void main() {
  final Moment time = Moment.now();

  trace('${TimeFormat.shortTime.format(time)}', tag: '12 Hour');
  trace('${TimeFormat.time.format(time)}', tag: '24 Hour');
}
