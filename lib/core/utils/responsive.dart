import 'package:flutter/material.dart';

/// Responsive sizing utility that scales dimensions proportionally
/// based on the device's screen size relative to a design baseline.
///
/// Design baseline: 393 x 852 (iPhone 14 / Pixel 7)
class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _textScale;

  static const double _designWidth = 393;
  static const double _designHeight = 852;

  /// Call this once in the root widget's build method.
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    // Use a balanced scale factor: average of width and height ratios
    _textScale = (_screenWidth / _designWidth + _screenHeight / _designHeight) / 2;
  }

  /// Scale a width value proportionally.
  static double w(double width) => width * (_screenWidth / _designWidth);

  /// Scale a height value proportionally.
  static double h(double height) => height * (_screenHeight / _designHeight);

  /// Scale a font size proportionally, clamped for readability.
  static double sp(double fontSize) => fontSize * _textScale.clamp(0.8, 1.4);

  /// Scale a radius proportionally.
  static double r(double radius) => radius * (_screenWidth / _designWidth);

  /// Screen width.
  static double get screenWidth => _screenWidth;

  /// Screen height.
  static double get screenHeight => _screenHeight;

  /// Symmetric horizontal padding scaled to screen.
  static EdgeInsets px(double value) =>
      EdgeInsets.symmetric(horizontal: w(value));

  /// Symmetric vertical padding scaled to screen.
  static EdgeInsets py(double value) =>
      EdgeInsets.symmetric(vertical: h(value));

  /// All-sides padding scaled to screen.
  static EdgeInsets pa(double value) => EdgeInsets.all(w(value));
}
