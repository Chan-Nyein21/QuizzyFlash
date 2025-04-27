import 'dart:async';

class TimerHelper {
  Timer? _timer;
  int remainingTime = 0;

  void start({
    required int duration,
    required Function(int) onTick,
    required Function onTimeUp,
  }) {
    remainingTime = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        onTick(remainingTime);
      } else {
        cancel();
        onTimeUp();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;
}
