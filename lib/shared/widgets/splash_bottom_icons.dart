// lib/features/auth/presentation/widgets/splash_bottom_icons.dart
import 'package:flutter/material.dart';

class SplashBottomIcons extends StatelessWidget {
  const SplashBottomIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIcon(Icons.wash_outlined),
        _buildIcon(Icons.shower_outlined),
        _buildIcon(Icons.bathtub_outlined),
        _buildIcon(Icons.architecture_outlined),
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      color: Colors.white.withOpacity(0.3),
      size: 28,
    );
  }
}