import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import '../../core/localization/app_localizations.dart';

class OnboardingPageItem extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final String imageUrl;
  final String? badgeKey;

  const OnboardingPageItem({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.imageUrl,
    this.badgeKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الصورة
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
            ),
          ),
          
          // البادج الاختياري (مثال: الخطوة الأخيرة)
          if (badgeKey != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECE8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                context.tr(badgeKey!),
                style: const TextStyle(color: Color(0xFFD96B42), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 15),
          ],

          // النصوص
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  context.tr(titleKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, fontFamily: 'Cairo', color: Color(0xFF1E2D3D)),
                ),
                const SizedBox(height: 15),
                Text(
                  context.tr(subtitleKey),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.6, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}