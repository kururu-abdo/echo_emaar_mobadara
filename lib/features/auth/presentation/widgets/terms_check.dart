// lib/features/auth/presentation/widgets/terms_checkbox.dart
import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // اتجاه عربي
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to Terms and Conditions Screen
          },
          child: const Text(
            'أوافق على الشروط والأحكام',
            style: TextStyle(color: Color(0xFF0D417D), decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(width: 8),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF0D417D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}