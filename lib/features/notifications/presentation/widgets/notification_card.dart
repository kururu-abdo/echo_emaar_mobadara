import 'package:echoemaar_commerce/features/notifications/data/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: notification.type == NotificationType.offer 
            ? const Border(right: BorderSide(color: Colors.orange, width: 4)) 
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(notification.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 250,
                      
                      child: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                    if (notification.type == NotificationType.order)
                      const Text('JUST NOW', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notification.body, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(NotificationType type) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (type) {
      case NotificationType.order:
        icon = Icons.local_shipping_outlined;
        bgColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF1D71A4);
        break;
      case NotificationType.offer:
        icon = Icons.local_offer_outlined;
        bgColor = const Color(0xFFFFF3E0);
        iconColor = Colors.orange;
        break;
      case NotificationType.payment:
        icon = Icons.check_circle_outline;
        bgColor = const Color(0xFFE8F5E9);
        iconColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}