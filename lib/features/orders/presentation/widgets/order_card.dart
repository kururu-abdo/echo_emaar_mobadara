import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';
import 'package:echoemaar_commerce/features/orders/presentation/pages/order_detail_page.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    bool isSale = order.state == 'sale';

    return GestureDetector(
      onTap: () {
      //go to details
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_)=> OrderDetailsPage(order: order.id,))
      );


      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _statusBadge(context, order.state),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(order.dateOrder.toString().split(' ')[0]),
                  const Spacer(),
                  Text(
                    "${order.amountTotal} SAR",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String state) {
  switch (state) {
    case 'draft': 
      return Colors.orange; // Quotation being prepared
    case 'sent': 
      return Colors.blue;   // Quotation sent to Assem
    case 'sale': 
      return Colors.green;  // Order Confirmed
    case 'done': 
      return Colors.teal;   // Order Locked/Finished
    case 'cancel': 
      return Colors.red;    // Order Cancelled
    default: 
      return Colors.grey;
  }
}

IconData getStatusIcon(String state) {
  switch (state) {
    case 'draft': return Icons.edit_note;
    case 'sent': return Icons.send;
    case 'sale': return Icons.check_circle;
    case 'done': return Icons.inventory;
    case 'cancel': return Icons.cancel;
    default: return Icons.help_outline;
  }
}
Widget _statusBadge(BuildContext context, String state) {
  final Color color = getStatusColor(state);
  final IconData icon = getStatusIcon(state);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12), // Very light tint
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          context.tr(state).toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
}