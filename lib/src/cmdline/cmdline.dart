void doNothing([dynamic _]) {}

Future<void> delay(int milliseconds, {int? seconds}) async {
  await Future.delayed(
    Duration(milliseconds: milliseconds, seconds: seconds ?? 0),
  ).whenComplete(() {
    return;
  });
}
