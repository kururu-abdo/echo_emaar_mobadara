import 'package:echoemaar_commerce/features/notifications/data/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  String _selectedFilter = 'All';

  List<NotificationModel> get notifications {
    if (_selectedFilter == 'Orders') {
      return _notifications.where((n) => n.type == NotificationType.order || n.type == NotificationType.payment).toList();
    } else if (_selectedFilter == 'Offers') {
      return _notifications.where((n) => n.type == NotificationType.offer).toList();
    }
    return _notifications;
  }

  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void markAllAsRead() {
    // منطق تحديث الحالة عبر API
    notifyListeners();
  }

  // دالة جلب البيانات من الـ API
  Future<void> fetchNotifications() async {
    // محاكاة جلب البيانات
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Order #AA-89021 is out for delivery',
        body: 'Our courier is on the way to your address...',
        timestamp: DateTime.now(),
        type: NotificationType.order,
      ),

      // تنبيهات اليوم (Today)
      NotificationModel(
        id: '1',
        title: 'Order #AA-89021 is out for delivery',
        body: 'Our courier is on the way to your address. Ensure someone is available to receive your artisan fixtures.',
        timestamp: DateTime.now(),
        type: NotificationType.order,
      ),
      NotificationModel(
        id: '2',
        title: 'Exclusive Offer: 20% off on all Matte Black faucets',
        body: 'Upgrade your bathroom aesthetics with our signature architectural collection. Limited time only.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.offer,
      ),
      
      // تنبيهات الأمس (Yesterday)
      NotificationModel(
        id: '3',
        title: 'Your payment for Order #AA-88542 was successful',
        body: 'Thank you for your purchase. We are now preparing your architectural plumbing components for shipment.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        type: NotificationType.payment,
      ),
      NotificationModel(
        id: '4',
        title: 'The Noir Collection',
        body: 'Experience the flow of elegance.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        type: NotificationType.offer,
        imageUrl: 'assets/images/noir_faucet.png', // رابط الصورة للعرض المميز
      ),
      NotificationModel(
        id: '5',
        title: 'Order #AA-88540 has been delivered',
        body: 'Your order was signed for by J. Doe. Please let us know if you need help with installation.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
        type: NotificationType.order,
      ),
      // إضافة باقي التنبيهات من الصورة...
    ];
    notifyListeners();
  }
}