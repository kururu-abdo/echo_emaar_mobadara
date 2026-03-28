// lib/features/auth/presentation/widgets/auth_header_card.dart
import 'package:flutter/material.dart';

class AuthHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imagePath;

  const AuthHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
          // إذا توفرت الصورة الخلفية الشفافة، يمكن وضعها هنا داخل الـ Column أو كـ Background للـ Container
        ],
      ),
    );
  }
}