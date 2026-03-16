import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';
import 'package:echoemaar_commerce/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:echoemaar_commerce/features/invoice/domain/usecases/get_invoices.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  final GetInvoices getInvoices;
  InvoiceProvider({required this.getInvoices});

  List<Invoice> invoices = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchInvoices() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await getInvoices(NoParams());
    result.fold(
      (failure) => error = failure.message,
      (data) => invoices = data,
    );

    isLoading = false;
    notifyListeners();
  }
}