import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_item_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final int order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
@override
void initState() {
  super.initState();
  Provider.of<OrderProvider>(context, listen: false).fetchOrderDetails(widget.order);

}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          final order = provider.currentOrder;

          if (provider.isDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (order == null) {
            return Center(child: Text(context.tr('order_not_found')));
          }

          return CustomScrollView(
            slivers: [
              // 1. Modern Header
              SliverAppBar.large(
                title: Text(order.name),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {}, // Share order details
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 2. Status Tracker Card
                      _buildTrackerCard(context, order),
                      const SizedBox(height: 24),

                      // 3. Items Section
                      DetailSection(
                        title: context.tr('orders.order_items'),
                        children: order.items.map((item) {
                          return OrderItemTile(item: item );
                        }).toList(),
                      ),

                      // 4. Shipping Address Section
                      DetailSection(
                        title: context.tr('checkout.shipping_address'),
                        children: [
                          _buildAddressCard(theme, order),
                        ],
                      ),

                      // 5. Payment Summary Section
                      DetailSection(
                        title: context.tr('checkout.payment_summary'),
                        children: [
                          _buildPriceSummary(context, theme, order),
                        ],
                      ),
                      
                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrackerCard(BuildContext context, OrderDetail order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OrderStatusTracker(currentState: order.deliveryStatus),
    );
  }

  Widget _buildAddressCard(ThemeData theme, OrderDetail order) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.address.name, style: theme.textTheme.titleSmall),
                  Text(
                    "${order.address.street}, ${order.address.city}, ${order.address.zip}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context, ThemeData theme, OrderDetail order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _priceRow(context.tr('subtotal'), "${order.total - order.tax} ${order.currency}", theme),
          const SizedBox(height: 8),
          _priceRow(context.tr('tax'), "${order.tax} ${order.currency}", theme),
          const Divider(height: 24),
          _priceRow(
            context.tr('total'), 
            "${order.total} ${order.currency}", 
            theme, 
            isTotal: true
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, ThemeData theme, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium),
        Text(
          value, 
          style: isTotal 
            ? theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold) 
            : theme.textTheme.bodyLarge
        ),
      ],
    );
  }
}


class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DetailSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}


class OrderStatusTracker extends StatelessWidget {
  final String currentState;

  const OrderStatusTracker({super.key, required this.currentState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define the lifecycle of an order
    final List<Map<String, dynamic>> steps = [
      {'state': context.tr('orders.pending'), 'icon': Icons.hourglass_empty},
      {'state': context.tr('orders.confirmed'), 'icon': Icons.assignment_turned_in},
      {'state': context.tr('orders.preparing'), 'icon': Icons.inventory_2},
      {'state':context.tr('orders.in_transit'), 'icon': Icons.local_shipping},
     
      {'state': context.tr('orders.delivered'), 'icon': Icons.auto_awesome},
            // {'state':context.tr('orders.partially_delivered'), 'icon': Icons.local_shipping},
            // {'state':context.tr('orders.canceled'), 'icon': Icons.close},

    
    ];

    // Calculate current progress index
    int currentIndex = _getStepIndex(currentState);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: List.generate(steps.length, (index) {
              bool isCompleted = index < currentIndex;
              bool isActive = index == currentIndex;
              bool isLast = index == steps.length - 1;

              return Expanded(
                flex: isLast ? 0 : 1,
                child: Row(
                  children: [
                    // --- The Step Node ---
                    _buildStepNode(
                      context,
                      icon: steps[index]['icon'],
                      isCompleted: isCompleted,
                      isActive: isActive,
                      colorScheme: colorScheme,
                    ),
                    
                    // --- The Connector Line ---
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: isCompleted 
                                ? colorScheme.primary 
                                : colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // --- Labels Row ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map((step) {
            int index = steps.indexOf(step);
            bool isPastOrCurrent = index <= currentIndex;
            return Expanded(
              child: Text(
                context.tr(step['state']), // Using your translation extension
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: isPastOrCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isPastOrCurrent 
                      ? colorScheme.onSurface 
                      : colorScheme.outline,
                  fontSize: 10,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepNode(
    BuildContext context, {
    required IconData icon,
    required bool isCompleted,
    required bool isActive,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted 
            ? colorScheme.primary 
            : isActive 
                ? colorScheme.primaryContainer 
                : colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: (isCompleted || isActive) 
              ? colorScheme.primary 
              : colorScheme.outlineVariant,
          width: 2,
        ),
        boxShadow: isActive ? [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: Icon(
        isCompleted ? Icons.check : icon,
        size: 16,
        color: isCompleted 
            ? colorScheme.onPrimary 
            : isActive 
                ? colorScheme.primary 
                : colorScheme.outline,
      ),
    );
  }

  int _getStepIndex(String state) {
    switch (state) {
      case 'pending': return 0;
      case 'confirmed': return 1;
      case 'preparing': return 2;
      case 'in_transit': return 3;
      case 'delivered': 
      case 'partially_delivered': return 4;
      default: return 0;
    }
  }
}


class OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const OrderItemTile({super.key, required this.item});
// Inside your OrderItemTile class

Widget _buildStatusRow(BuildContext context, ThemeData theme) {
  final bool isPartiallyDelivered = item.quantityDelivered < item.quantity && item.quantityDelivered > 0;
  final bool isNotFullyDelivered = item.quantityDelivered < item.quantity;
  
  // Only show if there's a discrepancy
  if (item.quantityDelivered == item.quantity && item.quantityInvoiced == item.quantity) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      children: [
        // 1. Delivery Badge
        if (isNotFullyDelivered)
          _buildBadge(
            label: "${context.tr('delivered')}: ${item.quantityDelivered.toInt()}/${item.quantity.toInt()}",
            color: Colors.green,
            theme: theme,
          ),
        const SizedBox(width: 8),
        // 2. Invoiced Badge
        if (item.quantityInvoiced != item.quantity)
          _buildBadge(
            label: "${context.tr('invoiced')}: ${item.quantityInvoiced.toInt()}",
            color: theme.colorScheme.tertiary,
            theme: theme,
          ),
      ],
    ),
  );
}

Widget _buildBadge({required String label, required Color color, required ThemeData theme}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // 1. Product Image with Network Handling
            _buildProductImage(colorScheme),
            const SizedBox(width: 16),

            // 2. Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Shows "Quantity x Price"
                  Text(
                    "${item.quantityDelivered.toInt()} x ${item.priceUnit}  SAR}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
// Add the new status row here

                  // Delivered Status Badge (if applicable)
                  if (item.quantity > 0) _buildDeliveredBadge(context, theme),

                  // _buildStatusRow(context, theme),
                ],
              ),
            ),

            // 3. Subtotal Price
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "${item.priceTotal} SAR",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 70,
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        child: item.image != null
            ? Image.network(
                item.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.inventory_2_outlined, color: colorScheme.outline),
              )
            : Icon(Icons.inventory_2_outlined, color: colorScheme.outline),
      ),
    );
  }

  Widget _buildDeliveredBadge(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "${context.tr('delivered')}: ${item.quantityDelivered.toInt()}",
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}