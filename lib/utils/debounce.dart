import 'dart:async';

debounce(int debounceTime, Timer timer, Function handler) {
  if (timer != null) {
    timer.cancel();
  }
  return new Timer(Duration(milliseconds: debounceTime), () {
    print("Debounce crossed");
    handler();
  });
}
