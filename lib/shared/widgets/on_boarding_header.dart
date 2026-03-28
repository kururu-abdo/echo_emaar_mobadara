import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import '../../core/localization/app_localizations.dart'; // مسار الترجمة

class OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingHeader({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الشعار
          Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF2A76A8)),
              const SizedBox(width: 5),
              Text(
                context.tr('onboarding_initiative'), 
                style: const TextStyle(color: Color(0xFF2A76A8), fontWeight: FontWeight.bold, fontFamily: 'Cairo')
              ),
            ],
          ),
          // زر التخطي
          TextButton(
            onPressed: onSkip, 
            child: Text(
              context.tr('onboarding_skip'), 
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Cairo')
            ),
          ),
        ],
      ),
    );
  }
}