import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/orders/presentation/providers/order_provider.dart';
import 'package:echoemaar_commerce/features/orders/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../config/themes/app_colors.dart' show AppColors;

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

@override
void initState() {
  super.initState();
  context.read<OrderProvider>().setFilter('all');
}
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light modern background
      appBar: AppBar(
        title: Text(context.tr('my_orders')),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                
                final displayOrders = provider.orders;
                
                if (displayOrders.isEmpty) {
                  return Center(child: Text(context.tr('no_orders_found')));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayOrders.length,
                  itemBuilder: (context, index) => OrderCard(order: displayOrders[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
   final provider = context.watch<OrderProvider>();
  final states = ['all', 'draft', 'sent', 'sale', 'done', 'cancel'];

  return SizedBox(
    height: 50,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: states.length,
      itemBuilder: (context, index) {
        final state = states[index];
        final isSelected = provider.selectedFilter == state;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            showCheckmark: false,
            label: Text(context.tr(state)),
            selected: isSelected,
            onSelected: (_) => provider.setFilter(state),
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
            ),
          ),
        );
      },
    ),
  );
  }

  Widget _filterChip(BuildContext context, String label, OrderProvider provider) {
    bool isSelected = provider.selectedFilter == label;
    return ChoiceChip(
      label: Text(context.tr(label)),
      selected: isSelected,
      onSelected: (_) => provider.setFilter(label),
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }
}