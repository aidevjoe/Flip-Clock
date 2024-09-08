import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'clock_theme.dart';
import 'flip_panel_plus.dart';

class FlipClockWidget extends StatefulWidget {
  final ClockTheme theme;

  const FlipClockWidget({
    super.key,
    required this.theme,
  });

  @override
  State<FlipClockWidget> createState() => _FlipClockWidgetState();
}

class _FlipClockWidgetState extends State<FlipClockWidget>
    with TickerProviderStateMixin {
  late StreamController<int> _hoursController;
  late StreamController<int> _minutesController;
  late StreamController<int> _secondsController;
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _hoursController = StreamController<int>.broadcast();
    _minutesController = StreamController<int>.broadcast();
    _secondsController = StreamController<int>.broadcast();
    _currentTime = DateTime.now();
    _updateTime();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateTime.now();
        _updateTime();
      });
    });
  }

  void _updateTime() {
    final newTime = DateTime.now();
    if (newTime.hour != _currentTime.hour) {
      _hoursController.add(newTime.hour);
    }
    if (newTime.minute != _currentTime.minute) {
      _minutesController.add(newTime.minute);
    }
    _secondsController.add(newTime.second);
    _currentTime = newTime;
  }

  @override
  void dispose() {
    _timer.cancel();
    _hoursController.close();
    _minutesController.close();
    _secondsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxHeight > constraints.maxWidth;
        final baseSize = _calculateBaseSize(constraints, isPortrait);

        return Container(
          color: widget.theme.backgroundColor,
          child: isPortrait
              ? _buildPortraitLayout(baseSize, constraints)
              : _buildLandscapeLayout(baseSize, constraints),
        );
      },
    );
  }

  double _calculateBaseSize(BoxConstraints constraints, bool isPortrait) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    if (isPortrait) {
      return math.min(maxWidth / 2.5, maxHeight / 8);
    } else {
      return math.min(maxWidth / 8, maxHeight / 2.5);
    }
  }

  Widget _buildPortraitLayout(double baseSize, BoxConstraints constraints) {
    final spacing = baseSize * 0.25;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFlipUnit(_hoursController.stream, baseSize, _currentTime.hour),
        SizedBox(height: spacing),
        _buildFlipUnit(
            _minutesController.stream, baseSize, _currentTime.minute),
        SizedBox(height: spacing),
        _buildFlipUnit(
            _secondsController.stream, baseSize, _currentTime.second),
      ],
    );
  }

  Widget _buildLandscapeLayout(double baseSize, BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth * 0.80;
    final unitWidth = availableWidth / 3.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFlipUnit(
            _hoursController.stream, baseSize, _currentTime.hour, unitWidth),
        _buildSeparator(baseSize),
        _buildFlipUnit(_minutesController.stream, baseSize, _currentTime.minute,
            unitWidth),
        _buildSeparator(baseSize),
        _buildFlipUnit(_secondsController.stream, baseSize, _currentTime.second,
            unitWidth),
      ],
    );
  }

  Widget _buildFlipUnit(Stream<int> stream, double baseSize, int initialValue,
      [double? width]) {
    return SizedBox(
      width: width ?? baseSize * 2.2,
      height: baseSize * 1.9,
      child: FlipPanelPlus<int>.stream(
        itemStream: stream,
        itemBuilder: (context, value) => _buildPairCard(value, baseSize),
        initValue: initialValue,
        duration: const Duration(milliseconds: 450),
        spacing: baseSize * 0.035,
        direction: FlipDirection.down,
      ),
    );
  }

  Widget _buildPairCard(int value, double baseSize) {
    return Container(
      decoration: BoxDecoration(
          color: widget.theme.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(baseSize * 0.1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(baseSize * 0.1),
        child: CustomPaint(
          painter: CardPainter(baseSize: baseSize, theme: widget.theme),
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: EdgeInsets.all(baseSize * 0.1),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: widget.theme.textColor,
                    fontSize: baseSize * 1.2,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(double baseSize) {
    return SizedBox(
      width: baseSize * 0.5,
      height: baseSize * 1.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSeparatorDot(baseSize),
          SizedBox(height: baseSize * 0.4),
          _buildSeparatorDot(baseSize),
        ],
      ),
    );
  }

  Widget _buildSeparatorDot(double baseSize) {
    return Container(
      width: baseSize * 0.15,
      height: baseSize * 0.15,
      decoration: BoxDecoration(
        color: widget.theme.secondaryTextColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.theme.secondaryTextColor.withOpacity(1),
            blurRadius: baseSize * 0.01,
            offset: Offset(0, baseSize * 0.01),
          ),
        ],
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final double baseSize;
  final ClockTheme theme;

  CardPainter({
    required this.baseSize,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw main background
    paint.color = theme.secondaryBackgroundColor;
    canvas.drawRect(rect, paint);

    // Draw horizontal line
    paint.color = theme.borderColor.withOpacity(0.5);
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
