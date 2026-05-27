import 'package:flutter/material.dart';
import 'colours.dart';

class BethTypography {
  static const String _fontFamily = 'Inter';
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: BethColours.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: BethColours.textPrimary,
  );
  
  static const TextStyle subheading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: BethColours.textPrimary,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BethColours.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BethColours.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BethColours.textMuted,
  );
  
  static const TextStyle affirmation = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: BethColours.textSecondary,
    fontStyle: FontStyle.italic,
    height: 1.4,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}