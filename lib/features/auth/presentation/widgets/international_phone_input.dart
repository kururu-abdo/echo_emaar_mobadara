import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InternationalPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(PhoneNumber) onInputChanged;
  final String? Function(String?)? validator;
  final String? initialCountryCode;
  
  const InternationalPhoneInput({
    Key? key,
    required this.controller,
    required this.onInputChanged,
    this.validator,
    this.initialCountryCode = 'US',
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: onInputChanged,
      textFieldController: controller,
      initialValue: PhoneNumber(isoCode: initialCountryCode),
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        showFlags: true,
        useEmoji: false,
        setSelectorButtonAsPrefixIcon: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter phone number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      spaceBetweenSelectorAndTextField: 0,
    );
  }
}