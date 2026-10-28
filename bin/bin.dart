import 'package:cmdline/cmdline.dart';

/// clear && dart run bin\bin.dart

void main() {
  // CommandLineDemo.demo();
  // CommandLineDemo.printMessages();

  Cli(name: 'Example', commands: [command]);
}

Command command = Command(
  name: 'get',
  run: (input) {
    dev('Testing get');
  },
);
