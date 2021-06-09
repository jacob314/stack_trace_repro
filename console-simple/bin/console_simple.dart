import 'dart:async';

useATimerToGetOnTheEventLoopWithoutAsync() {
  return Timer(Duration(seconds: 1), handleTimeout);
}
void handleTimeout() {  // callback function
  nonAsyncFunc();
}

void nonAsyncFunc() {
    print("""nonAsyncFunc. Stack trace correctly includes handleTimeout.
    It is correct this stacktrace does not include main as Timer was used rather than
    aysnc.

    ${StackTrace.current}""");
    func1();
}

Future<void> func2() async {
  await Future.delayed(Duration(seconds: 1));
  print("""Func2. Stack trace should be:
  func2
  <asynchronous suspension>
  func1
  <asynchronous suspension>
  nonAsyncFunc
  useATimerToGetOnTheEventLoopWithoutAsync
  ...

  But is instead:
  ${StackTrace.current}
  """);
  await Future.delayed(Duration(seconds: 1));
}


Future<void> func1() async {
    await Future.delayed(Duration(seconds: 1));
  print("""Func1. Stack trace should be:
  func1
  <asynchronous suspension>
  nonAsyncFunc
  useATimerToGetOnTheEventLoopWithoutAsync
  ...

  But is instead:
  ${StackTrace.current}
  """);

  await func2();
}

void main(List<String> arguments) async {
  print("Start main. ${StackTrace.current}");
  useATimerToGetOnTheEventLoopWithoutAsync();
}
