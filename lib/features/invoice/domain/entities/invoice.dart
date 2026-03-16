import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final int id;
  final String name;
  final DateTime? date;
  final DateTime? dueDate;
  final String state;
  final String paymentState;
  final double amountTotal;
  final double amountResidual;
  final String? accessToken;

  const Invoice({
    required this.id,
    required this.name,
    this.date,
    this.dueDate,
    required this.state,
    required this.paymentState,
    required this.amountTotal,
    required this.amountResidual,
    this.accessToken,
  });

  @override
  List<Object?> get props => [id, name, state, paymentState];
}