import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onTimeUp;
  final bool autoStart;
  final bool showWarning;
  final Duration? warningThreshold;

  const TimerWidget({
    super.key,
    required this.duration,
    this.onTimeUp,
    this.autoStart = true,
    this.showWarning = true,
    this.warningThreshold,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _remainingTime;
  late Duration _warningThreshold;
  bool _isRunning = false;
  bool _isWarning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _warningThreshold = widget.warningThreshold ?? Duration(minutes: 5);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.autoStart) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);

          // Check for warning threshold
          if (widget.showWarning &&
              _remainingTime.inSeconds <= _warningThreshold.inSeconds &&
              !_isWarning) {
            _isWarning = true;
            _pulseController.repeat(reverse: true);
          }

          // Check if time is up
          if (_remainingTime.inSeconds == 0) {
            _timer.cancel();
            _isRunning = false;
            _pulseController.stop();
            widget.onTimeUp?.call();
          }
        }
      });
    });
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
      _pulseController.stop();
    }
  }

  void resumeTimer() {
    if (!_isRunning && _remainingTime.inSeconds > 0) {
      startTimer();
    }
  }

  void resetTimer() {
    _timer.cancel();
    _isRunning = false;
    _isWarning = false;
    _pulseController.stop();
    setState(() {
      _remainingTime = widget.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isWarning ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getTimerColor(),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getTimerBorderColor(),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: _getTimerTextColor(),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_remainingTime),
                  style: TextStyle(
                    color: _getTimerTextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTimerColor() {
    if (_remainingTime.inSeconds == 0) {
      return Colors.red[100]!;
    } else if (_isWarning) {
      return Colors.orange[100]!;
    } else {
      return Colors.blue[100]!;
    }
  }

  Color _getTimerBorderColor() {
    if (_remainingTime.inSeconds == 0) {
      return Colors.red;
    } else if (_isWarning) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  Color _getTimerTextColor() {
    if (_remainingTime.inSeconds == 0) {
      return Colors.red[800]!;
    } else if (_isWarning) {
      return Colors.orange[800]!;
    } else {
      return Colors.blue[800]!;
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}

class CircularTimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onTimeUp;
  final bool autoStart;
  final double size;

  const CircularTimerWidget({
    super.key,
    required this.duration,
    this.onTimeUp,
    this.autoStart = true,
    this.size = 60,
  });

  @override
  State<CircularTimerWidget> createState() => _CircularTimerWidgetState();
}

class _CircularTimerWidgetState extends State<CircularTimerWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _remainingTime;
  late Duration _totalTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _totalTime = widget.duration;

    if (widget.autoStart) {
      startTimer();
    }
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);

          if (_remainingTime.inSeconds == 0) {
            _timer.cancel();
            _isRunning = false;
            widget.onTimeUp?.call();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalTime.inSeconds > 0
        ? (_totalTime.inSeconds - _remainingTime.inSeconds) / _totalTime.inSeconds
        : 0.0;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(),
            ),
          ),
          Center(
            child: Text(
              _formatTime(_remainingTime),
              style: TextStyle(
                fontSize: widget.size * 0.2,
                fontWeight: FontWeight.bold,
                color: _getProgressColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    final percentage = _remainingTime.inSeconds / _totalTime.inSeconds;

    if (percentage <= 0.1) {
      return Colors.red;
    } else if (percentage <= 0.25) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final TextStyle? textStyle;

  const CountdownTimer({
    super.key,
    required this.seconds,
    this.onComplete,
    this.textStyle,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _animationController.forward().then((_) {
            _animationController.reverse();
          });

          if (_remainingSeconds == 0) {
            timer.cancel();
            widget.onComplete?.call();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Text(
            _remainingSeconds.toString(),
            style: widget.textStyle ?? TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _getCountdownColor(),
            ),
          ),
        );
      },
    );
  }

  Color _getCountdownColor() {
    if (_remainingSeconds <= 3) {
      return Colors.red;
    } else if (_remainingSeconds <= 5) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }
}