enum NotificationType { order, offer, payment }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? imageUrl; // للعروض المميزة مثل "The Noir Collection"

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.imageUrl,
  });
}