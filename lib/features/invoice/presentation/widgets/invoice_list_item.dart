import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';
import 'package:flutter/material.dart';
// import your extension for context.tr and context.theme

class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onTap;

  const InvoiceListItem({super.key, required this.invoice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(invoice.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            _buildStatusBadge(context, invoice.state),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("${context.tr('date')}: ${invoice.date?.toString().split(' ')[0] ?? ''}"),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${context.tr('total')}: ${invoice.amountTotal} SAR"),
                if (invoice.amountResidual > 0)
                  Text(
                    "${context.tr('remaining')}: ${invoice.amountResidual} SAR",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String state) {
    Color color;
    switch (state) {
      case 'paid':
      case 'posted'
      : color = Colors.green; break;
      case 'in_payment':
      case 'draft':
       color = Colors.blue; break;
      case 'not_paid': color = Colors.orange; break;
      case 'reversed': color = Colors.red; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        context.tr(state),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}