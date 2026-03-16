import 'package:equatable/equatable.dart';

enum PaymentType {
  cod, // Cash on Delivery
  card, // Credit/Debit Card
}

class PaymentMethod extends Equatable {
  final PaymentType type;
  final String displayName;
  final String? cardNumber; // Last 4 digits for saved cards
  final String? cardHolderName;
  final String? expiryDate; // MM/YY
  final String? cvv; // Only for new cards, not stored

  const PaymentMethod({
    required this.type,
    required this.displayName,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cvv,
  });

  factory PaymentMethod.cod() {
    return const PaymentMethod(
      type: PaymentType.cod,
      displayName: 'Cash on Delivery',
    );
  }

  factory PaymentMethod.card({
    required String cardNumber,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
  }) {
    return PaymentMethod(
      type: PaymentType.card,
      displayName: 'Credit/Debit Card',
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    );
  }

  bool get isCOD => type == PaymentType.cod;
  bool get isCard => type == PaymentType.card;

  String get maskedCardNumber {
    if (cardNumber == null) return '';
    if (cardNumber!.length < 4) return cardNumber!;
    return '**** **** **** ${cardNumber!.substring(cardNumber!.length - 4)}';
  }

  @override
  List<Object?> get props => [
        type,
        displayName,
        cardNumber,
        cardHolderName,
        expiryDate,
        cvv,
      ];
}