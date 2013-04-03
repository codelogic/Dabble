library dabble.timer;

import "dart:async";

class ResetTimer {
  Timer _timer;
  Function _callback;
  Duration _timeout;

  ResetTimer(Duration timeout, void callback()) {
    _callback = callback;
    _timeout = timeout;
    reset();
  }

  void reset() {
    if(_timer != null)
      _timer.cancel();

    _timer = new Timer(_timeout, _callback);
  }
}