import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/invoice/presentation/providers/invoice_provider.dart';
import 'package:echoemaar_commerce/features/invoice/presentation/widgets/invoice_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  void initState() {
    super.initState();
    // Use microtask to fetch data after the first build
    Future.microtask(() => context.read<InvoiceProvider>().fetchInvoices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('my_invoices')),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.invoices.isEmpty) {
            return Center(child: Text(context.tr('no_invoices_found')));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.invoices.length,
            itemBuilder: (context, index) {
              return InvoiceListItem(
                invoice: provider.invoices[index],
                onTap: () {
                  // Navigate to detail or open Odoo PDF link
                },
              );
            },
          );
        },
      ),
    );
  }
}