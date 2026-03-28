import 'package:echoemaar_commerce/features/notifications/presentation/providers/notification_provider.dart';
import 'package:echoemaar_commerce/features/notifications/presentation/widgets/notification_card.dart';
import 'package:echoemaar_commerce/features/notifications/presentation/widgets/promotion_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){

context.read<NotificationProvider>().fetchNotifications();

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Color(0xFF1D71A4), fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
            child: const Text('Mark all as read'),
          )
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterBar(provider),
              Expanded(
                
                child: ListView.builder(
                 
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    final item = provider.notifications[index];
                    return 
                    
                     item.imageUrl != null 
                        ? PromotionCard(notification: item) 
                        : NotificationCard(notification: item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(NotificationProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['All', 'Orders', 'Offers'].map((filter) {
          final isSelected = provider.selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => provider.setFilter(filter),
            selectedColor: const Color(0xFF1D71A4),
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          );
        }).toList(),
      ),
    );
  }
}