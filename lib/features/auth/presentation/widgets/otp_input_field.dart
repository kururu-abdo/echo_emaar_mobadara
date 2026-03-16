import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String) onCompleted;
  
  const OtpInputField({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.onCompleted,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => _buildOtpBox(context, index),
      ),
    );
  }
  
  Widget _buildOtpBox(BuildContext context, int index) {
    return SizedBox(
      width: context.widthPercent(15),
      height: context.widthPercent(12),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: context.colors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
            borderSide: BorderSide(color: context.colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
            borderSide: BorderSide(color: context.colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
            borderSide: BorderSide(color: context.colors.primary, width: 2),
          ),
          filled: true,
          fillColor: context.colors.inputBackground,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              focusNodes[index + 1].requestFocus();
            } else {
              // All boxes filled, submit OTP
              final otp = controllers.map((c) => c.text).join();
              if (otp.length == 6) {
                onCompleted(otp);
              }
            }
          } else {
            // Move back on delete
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }
}