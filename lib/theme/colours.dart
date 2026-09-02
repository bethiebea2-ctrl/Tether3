import 'package:flutter/material.dart';

class BethColours {
  // Primary palette — warm, calm, intentional
  static const Color primary = Color(0xFF6C5B7B);        // Soft plum
  static const Color primaryLight = Color(0xFF9B8FAA);
  static const Color primaryDark = Color(0xFF4A3F54);
  
  // Surface colours
  static const Color background = Color(0xFFFAF8F5);      // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F2EF);
  
  // Text
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF9E9E9E);
  
  // Status colours
  static const Color green = Color(0xFF66BB6A);
  static const Color amber = Color(0xFFFFA726);
  static const Color red = Color(0xFFEF5350);
  
  // Event category colours (spec v3)
  static const Color evander = Color(0xFF7EC8E3);    // Soft blue
  static const Color ant = Color(0xFF66BB6A);         // Deep green
  static const Color beth = Color(0xFFFFA726);        // Warm amber
  static const Color family = Color(0xFFB8A9D4);      // Soft purple
  static const Color work = Color(0xFFFF9800);        // Orange
  static const Color parents = Color(0xFF4DB6AC);     // Teal
  static const Color social = Color(0xFFF06292);      // Pink
  
  // Instance colours
  static const Color instanceActive = Color(0xFF81C784);
  static const Color instancePending = Color(0xFFBDBDBD);
  
  // Status Shield
  static const Color statusOpen = Color(0xFF81C784);
  static const Color statusHeadsDown = Color(0xFFFFB74D);
  
  // Medication status
  static const Color medAvailable = Color(0xFF81C784);
  static const Color medWithinHour = Color(0xFFFFA726);
  static const Color medWaiting = Color(0xFFEF5350);
  
  static Color fromHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}