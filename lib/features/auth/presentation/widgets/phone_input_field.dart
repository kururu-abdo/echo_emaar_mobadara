// lib/features/auth/presentation/widgets/phone_input_field.dart
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onFullNumberSaved;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.onFullNumberSaved,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String initialCountry = 'SA'; // الافتراضي السعودية كما في تصميم صدى الإعمار
  PhoneNumber number = PhoneNumber(isoCode: 'SA');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9), // نفس خلفية AuthInputField
        borderRadius: BorderRadius.circular(12),
      ),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          this.number = number;
        },
        onSaved: (PhoneNumber number) {
          // المنطق المطلوب: إذا بدأ بـ 0 يتم حذفه، وإذا لم يبدأ يتم إرسال الرقم كما هو مع كود الدولة
          String rawNumber = widget.controller.text.trim();
          if (rawNumber.startsWith('0')) {
            rawNumber = rawNumber.substring(1);
          }
          // إرسال الرقم النهائي (كود الدولة + الرقم بدون صفر البداية)
          widget.onFullNumberSaved('${number.dialCode}$rawNumber');
        },
        textFieldController: widget.controller,
        formatInput: false,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // يتيح البحث عن الدولة في نافذة سفلية
          showFlags: true,
          useEmoji: false,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        initialValue: number,
        // تحديد الحد الأقصى للطول بـ 10 أرقام
        maxLength: 10,
        textAlign: TextAlign.end, // محاذاة لليمين مثل AuthInputField
        cursorColor: const Color(0xFF0D417D),
        inputDecoration: InputDecoration(
        hintText: '5xxxxxxxxx',
        hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF1F4F9), // خلفية الحقل الفاتحة
        // prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFFA0AEC0), size: 20) : null,
        // suffixIcon: GestureDetector(
        //   onTap: onSuffixTap,
        //   child: Icon(suffixIcon, color: const Color(0xFFA0AEC0), size: 22),
        // ),
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
        )
        // تخصيص شكل اختيار الدولة
        // selectorTextStyle: const TextStyle(color: Color(0xFF0D417D), fontWeight: FontWeight.bold),
      ),
    );
  }
}