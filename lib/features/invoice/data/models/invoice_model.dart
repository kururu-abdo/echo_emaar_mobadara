import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.name,
    super.date,
    super.dueDate,
    required super.state,
    required super.paymentState,
    required super.amountTotal,
    required super.amountResidual,
    super.accessToken,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      accessToken: json['access_token'],
      state: json['state'] ?? '',
      amountTotal: (json['amount_total'] as num?)?.toDouble() ?? 0.0,
      paymentState: json['payment_state'] ?? '',
      amountResidual: (json['amount_residual'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Invoice toEntity() => this; // Since Model extends Entity
}