import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/payment_method.dart';

class PaymentMethodSelector extends StatefulWidget {
  final PaymentMethod? selectedMethod;
  final ValueChanged<PaymentMethod> onSelectMethod;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelectMethod,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentType? _selectedType;
  final _cardFormKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _cardHolderCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedMethod?.type;
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardHolderCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // COD Option
        _PaymentOption(
          type: PaymentType.cod,
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive',
          icon: Icons.money_rounded,
          isSelected: _selectedType == PaymentType.cod,
          onTap: () {
            setState(() => _selectedType = PaymentType.cod);
            widget.onSelectMethod(PaymentMethod.cod());
          },
        ),
        const SizedBox(height: 12),

        // Card Option
        _PaymentOption(
          type: PaymentType.card,
          title: 'Credit/Debit Card',
          subtitle: 'Visa, Mastercard, Amex',
          icon: Icons.credit_card_rounded,
          isSelected: _selectedType == PaymentType.card,
          onTap: () => setState(() => _selectedType = PaymentType.card),
        ),

        // Card Form (expands when card is selected)
        if (_selectedType == PaymentType.card) ...[
          const SizedBox(height: 16),
          _CardForm(
            formKey: _cardFormKey,
            cardNumberCtrl: _cardNumberCtrl,
            cardHolderCtrl: _cardHolderCtrl,
            expiryCtrl: _expiryCtrl,
            cvvCtrl: _cvvCtrl,
            onSubmit: () {
              if (_cardFormKey.currentState!.validate()) {
                widget.onSelectMethod(PaymentMethod.card(
                  cardNumber: _cardNumberCtrl.text,
                  cardHolderName: _cardHolderCtrl.text,
                  expiryDate: _expiryCtrl.text,
                  cvv: _cvvCtrl.text,
                ));
              }
            },
          ),
        ],
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final PaymentType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withOpacity(.1)
                    : colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Radio
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberCtrl;
  final TextEditingController cardHolderCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;
  final VoidCallback onSubmit;

  const _CardForm({
    required this.formKey,
    required this.cardNumberCtrl,
    required this.cardHolderCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Card Number
            TextFormField(
              controller: cardNumberCtrl,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card_rounded),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (val.replaceAll(' ', '').length < 16) {
                  return 'Invalid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Card Holder
            TextFormField(
              controller: cardHolderCtrl,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'JOHN DOE',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Expiry + CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: expiryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Expiry',
                      hintText: 'MM/YY',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryDateFormatter(),
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      if (val.length < 5) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cvvCtrl,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      if (val.length < 3) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Card Number Formatter (adds spaces: 1234 5678 9012 3456)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Expiry Date Formatter (adds slash: MM/YY)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length >= 3) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return newValue;
  }
}
