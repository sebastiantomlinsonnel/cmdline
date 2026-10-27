import 'package:cmdline/cmdline.dart';

class CommandLineDemo {
  const CommandLineDemo._();

  static Future<String> demo() async {
    Logger.startSpinner('Starting logger');
    await delay(0, seconds: 3);
    Logger.stopSpinner('Loading Complete!', Level.pass);
    return Logger.instance.getString('Built, not logged', Level.debug);
  }

  static void printMessages() {
    trace('This is a trace message');
    debug('This is a $BOLD debug message');
    fail('This type shows that something has FAILED');
    Logger.instance.showTimestampInOutput = true;
    pass('This type shows that something has NOT failed');
    warn('This will show when you want to warn');
    dev('Dev messages only show in debug mode and aren\'t logged');
  }
}
