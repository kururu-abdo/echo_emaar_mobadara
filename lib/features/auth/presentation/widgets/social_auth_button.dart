// lib/features/auth/presentation/widgets/social_auth_buttons.dart
import 'package:flutter/material.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('أو التسجيل عبر', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12)),
            ),
            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton('assets/icons/google.png'), // تأكد من توفر الأيقونات في الـ Assets
            const SizedBox(width: 24),
            _buildSocialButton('assets/icons/facebook.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String iconPath) {
    return Container(
      width: 70,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Image.asset(iconPath, height: 24),
      ),
    );
  }
}