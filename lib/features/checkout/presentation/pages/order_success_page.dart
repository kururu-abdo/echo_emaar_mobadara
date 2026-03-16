import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mtrl;
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/routes/route_names.dart';
import '../../domain/entities/order_confirmation.dart';

class OrderSuccessPage extends StatefulWidget {
  final OrderConfirmation confirmation;

  const OrderSuccessPage({super.key, required this.confirmation});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: const SizedBox.shrink(), // Hide back button
        title:  Text('orders.order_confirmed'.tr()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: spacing.pagePadding(context),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        spacing.verticalLG,

                        // Success Animation
                        // Note: Replace with actual Lottie file or use custom animation
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: colors.success.withOpacity(.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 100,
                            color: colors.success,
                          ),
                        ),

                        spacing.verticalLG,

                        // Success Message
                        Text(
                          'success.order_placed'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        spacing.verticalSM,

                        Text(
                        'success.thank_you'.tr(),
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 16,
                          ),
                        ),

                        spacing.verticalXL,

                        // Order Details Card
                        _OrderDetailsCard(confirmation: widget.confirmation),

                        spacing.verticalLG,

                        // Estimated Delivery
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.local_shipping_outlined,
                                  color: colors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Estimated Delivery',
                                      style: TextStyle(
                                        color: colors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(
                                          widget.confirmation.orderDate),
                                      style: TextStyle(
                                        color: colors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        spacing.verticalXXL,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: spacing.pagePadding(context).copyWith(
                    top: spacing.md,
                    bottom: spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteNames.orderDetail,
                        arguments: widget.confirmation.id.toString()
                        // pathParameters: {
                        //   'id': widget.confirmation.id.toString()
                        // },
                      ),
                      child:  Text('orders.track_order'.tr()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        // Clear navigation stack and go home
                        // context.go(RouteNames.home);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const Dashboard()), (_)=>false);
                      },
                      child:  Text('cart.continue_shopping'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ═══════════════════════════════════════════════════════════════════
// Order Details Card
// ═══════════════════════════════════════════════════════════════════

class _OrderDetailsCard extends StatelessWidget {
  final OrderConfirmation confirmation;

  const _OrderDetailsCard({required this.confirmation});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Number
          _DetailRow(
            label: 'Order Number',
            value: '#${confirmation.orderReference}',
            valueStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Total Amount
          _DetailRowCurrency(
            label: 'Total Amount',
            value: confirmation.totalAmount.toStringAsFixed(2),
            valueStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: colors.primary,
            ),
          ),
          // const SizedBox(height: 16),

          // Payment Method
          // _DetailRow(
          //   label: 'Payment Method',
          //   value: confirmation.paymentMethod,
          // ),
          const SizedBox(height: 16),

          // Order Date
          _DetailRow(
            label: 'Order Date',
            value: _formatDateTime(confirmation.orderDate),
          ),
          const SizedBox(height: 16),

          // Shipping Address
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Shipping Address',
              //   style: TextStyle(
              //     color: colors.textSecondary,
              //     fontSize: 13,
              //   ),
              // ),
              // const SizedBox(height: 6),
              // Text(
              //   confirmation.a,
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w500,
              //     fontSize: 14,
              //     height: 1.5,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _DetailRowCurrency extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRowCurrency({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [



        

     Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 13,
          ),
        ),



                   Directionality(
              textDirection:mtrl. TextDirection.ltr,
                      child: Row(
                         mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                        children: [

                                         Image.asset('assets/icons/SAR.png' , width: 14, height: 14,                       
                                            color: colors.primary,
),

                          
 Flexible(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
            textAlign: TextAlign.right,
          ),
        ),
                     
                        ],
                      ),
                    ),
                    
     
       
      ],
    );
  }
}


