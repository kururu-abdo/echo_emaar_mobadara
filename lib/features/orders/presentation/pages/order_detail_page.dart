import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_item_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(context.tr('Track Order')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          final order = provider.currentOrder;

          if (provider.isDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (order == null) {
            return Center(child: Text(context.tr('order_not_found')));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Product Card at Top
                _buildProductCard(context, order),

                // 2. Order Details Card
                _buildOrderDetailsCard(context, order),

                // 3. Order Status Section Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    context.tr('Order Status'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 4. Vertical Timeline
                _buildVerticalTimeline(context, order),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // Product Card with Image, Name, Color, Price
  Widget _buildProductCard(BuildContext context, OrderDetail order) {
    final theme = Theme.of(context);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    if (firstItem == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: theme.colorScheme.surfaceContainerHighest,
              child: firstItem.image != null
                  ? Image.network(
                      firstItem.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: theme.colorScheme.outline,
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      size: 32,
                      color: theme.colorScheme.outline,
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstItem.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Color: ${firstItem.name}', // Replace with actual color if available
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹ ${firstItem.priceTotal}*',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Order Details Card
  Widget _buildOrderDetailsCard(BuildContext context, OrderDetail order) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Order Details'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            context.tr('Expected Delivery Date'),
            _formatDate(order.date.add(const Duration(days: 5))),
            theme,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            context.tr('Order ID'),
            '#${order.name}',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM, yyyy').format(date);
  }

  // Vertical Timeline
  Widget _buildVerticalTimeline(BuildContext context, OrderDetail order) {
    final theme = Theme.of(context);
    
    final List<TimelineStep> steps = [
      TimelineStep(
        title: context.tr('status_placed'),
        timestamp: _formatDateTime(order.date),
        isCompleted: true,
        icon: Icons.check_circle,
      ),
      TimelineStep(
        title: context.tr('status_packed'),
        timestamp: order.deliveryStatus == 'pending' 
            ? null 
            : _formatDateTime(order.date.add(const Duration(hours: 21))),
        isCompleted: ['confirmed', 'preparing', 'in_transit', 'delivered']
            .contains(order.deliveryStatus),
        icon: Icons.inventory_2_outlined,
      ),
      TimelineStep(
        title: context.tr('status_shipped'),
        timestamp: ['in_transit', 'delivered'].contains(order.deliveryStatus)
            ? _formatDateTime(order.date.add(const Duration(days: 1, hours: 6)))
            : null,
        isCompleted: ['in_transit', 'delivered'].contains(order.deliveryStatus),
        icon: Icons.local_shipping_outlined,
      ),
      TimelineStep(
        title: context.tr('Out For Delivery'),
        timestamp: null,
        isCompleted: false,
        isExpected: true,
        expectedDate: _formatExpectedDate(order.date.add(const Duration(days: 4))),
        icon: Icons.delivery_dining_outlined,
      ),
      TimelineStep(
        title: context.tr('status_delivered'),
        timestamp: null,
        isCompleted: order.deliveryStatus == 'delivered',
        isExpected: order.deliveryStatus != 'delivered',
        expectedDate: order.deliveryStatus != 'delivered'
            ? _formatExpectedDate(order.date.add(const Duration(days: 5)))
            : null,
        icon: Icons.check_circle_outline,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;

          return _buildTimelineItem(
            context,
            step,
            isLast: isLast,
            theme: theme,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    TimelineStep step, {
    required bool isLast,
    required ThemeData theme,
  }) {
    final bool isActive = step.isCompleted && !isLast;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Line & Icon
        Column(
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: Icon(
                step.isCompleted ? Icons.check : step.icon,
                size: 18,
                color: step.isCompleted
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            
            // Vertical Line
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: step.isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant.withOpacity(0.3),
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Step Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: step.isCompleted ? FontWeight.bold : FontWeight.w500,
                    color: step.isCompleted
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                if (step.timestamp != null)
                  Text(
                    step.timestamp!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (step.isExpected && step.expectedDate != null)
                  Text(
                    'Expected By ${step.expectedDate}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }

  String _formatExpectedDate(DateTime date) {
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }
}

// Timeline Step Model
class TimelineStep {
  final String title;
  final String? timestamp;
  final bool isCompleted;
  final bool isExpected;
  final String? expectedDate;
  final IconData icon;

  TimelineStep({
    required this.title,
    this.timestamp,
    required this.isCompleted,
    this.isExpected = false,
    this.expectedDate,
    required this.icon,
  });
}

// Keep existing OrderItemTile and other widgets...
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

class OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const OrderItemTile({super.key, required this.item});

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
            _buildProductImage(colorScheme),
            const SizedBox(width: 16),
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
                  Text(
                    "${item.quantityDelivered.toInt()} x ${item.priceUnit} SAR",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  if (item.quantity > 0) _buildDeliveredBadge(context, theme),
                ],
              ),
            ),
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