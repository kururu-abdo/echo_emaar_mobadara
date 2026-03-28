// lib/features/auth/presentation/widgets/auth_redirect_link.dart
import 'package:flutter/material.dart';

class AuthRedirectLink extends StatelessWidget {
  final String promptText;
  final String linkText;
  final VoidCallback onTap;

  const AuthRedirectLink({
    super.key,
    required this.promptText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText, style: const TextStyle(color: Color(0xFF718096), fontSize: 14)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF0D417D),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}