import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import '../../core/localization/app_localizations.dart';

class OnboardingFooter extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const OnboardingFooter({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    bool isLastPage = currentIndex == totalPages - 1;
    bool isFirstPage = currentIndex == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر السابق (يختفي في الصفحة الأولى)
          Opacity(
            opacity: isFirstPage ? 0.0 : 1.0,
            child: TextButton(
              onPressed: isFirstPage ? null : onPrev,
              child: Row(
                children: [
                  Text(context.tr('onboarding_prev'), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black87), // سهم يتجه يميناً في RTL
                ],
              ),
            ),
          ),

          // المؤشر (Dots)
          Row(
            children: List.generate(totalPages, (index) => _buildDot(index)),
          ),

          // زر التالي / ابدأ الآن
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A76A8), // الأزرق الخاص بالتصميم
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white), // سهم لليسار في RTL
                const SizedBox(width: 8),
                Text(
                  isLastPage ? context.tr('onboarding_start') : context.tr('onboarding_next'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A76A8) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}