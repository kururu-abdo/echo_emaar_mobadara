// lib/features/auth/presentation/widgets/auth_input_field.dart
import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? suffixIcon; // الأيقونة اليسرى في العربية
  final IconData? prefixIcon; // الأيقونة اليمنى (اختيارية كالقفل)
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      textAlign: TextAlign.end, // النص عربي
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF1F4F9), // خلفية الحقل الفاتحة
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFFA0AEC0), size: 20) : null,
        suffixIcon: GestureDetector(
          onTap: onSuffixTap,
          child: Icon(suffixIcon, color: const Color(0xFFA0AEC0), size: 22),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D417D), width: 1),
        ),
      ),
    );
  }
}