

import 'package:flutter/material.dart';

class ClockTheme {
  final String name;
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color borderColor;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color? shadowColor;

  const ClockTheme({
    required this.name,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.borderColor,
    required this.hourHandColor,
    required this.minuteHandColor,
    required this.secondHandColor,
    this.shadowColor,
  });

  static final List<ClockTheme> themes = [
    const ClockTheme(
      name: "Light",
      backgroundColor: Color(0xFFF0F4F8),
      secondaryBackgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF2C3E50),
      secondaryTextColor: Color(0xFFE0E6ED),
      borderColor: Color(0xFFBDC3C7),
      hourHandColor: Color(0xFF2C3E50),
      minuteHandColor: Color(0xFF2C3E50),
      secondHandColor: Color(0xFFE74C3C),
    ),
    const ClockTheme(
      name: "Dark",
      backgroundColor: Colors.black,
      secondaryBackgroundColor: Color(0xFF212121),
      textColor: Colors.white,
      secondaryTextColor: Color(0xFF424242),
      borderColor: Color(0xFF424242),
      hourHandColor: Color(0xFFECEFF1),
      minuteHandColor: Color(0xFFECEFF1),
      secondHandColor: Color(0xFFE74C3C),
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockTheme &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}