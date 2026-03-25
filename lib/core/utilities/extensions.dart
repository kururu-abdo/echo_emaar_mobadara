import 'package:flutter/material.dart';

extension GradientToDecoration on Gradient {
  /// Converts a Gradient directly into a BoxDecoration
  BoxDecoration toDecoration() => BoxDecoration(gradient: this);
}