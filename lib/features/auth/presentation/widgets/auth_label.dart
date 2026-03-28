// lib/features/auth/presentation/widgets/auth_label.dart
import 'package:flutter/material.dart';

class AuthLabel extends StatelessWidget {
  final String text;
  const AuthLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D417D), // اللون الأزرق الغامق حسب التصميم
        ),
      ),
    );
  }
}