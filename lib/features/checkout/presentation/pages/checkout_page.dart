// ═══════════════════════════════════════════════════════════════════
// FILE: features/checkout/presentation/pages/checkout_page.dart
// ═══════════════════════════════════════════════════════════════════

import 'dart:developer';

import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/address_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_state_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country_state.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_confirmation.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/pages/order_success_page.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/widgets/order_summary_section.dart';
import 'package:echoemaar_commerce/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/checkout_bloc.dart';
import '../widgets/address_selector.dart';
import '../widgets/payment_method_selector.dart';

// lib/features/checkout/presentation/pages/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
// استيراد المكونات المحدثة بالأسفل...
/*
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية فاتحة جداً حسب التصميم
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D7A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('AQUA ARTISAN', 
              style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 8),
            Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text('SECURE CHECKOUT', 
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10, letterSpacing: 1)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Shipping Address Section
            _buildSectionHeader('Shipping Address', onAction: () {}),
            const SizedBox(height: 12),
            const _ShippingAddressCard(),

            const SizedBox(height: 32),

            // 2. Delivery Method Section
            _buildSectionHeader('Delivery Method'),
            const SizedBox(height: 12),
            const _DeliveryMethodSelector(),

            const SizedBox(height: 32),

            // 3. Payment Method Section
            _buildSectionHeader('Payment Method'),
            const SizedBox(height: 12),
            const _PaymentMethodTabs(),
            const SizedBox(height: 16),
            const _CreditCardForm(),

            const SizedBox(height: 32),

            // 4. Order Summary Section
            const _OrderSummaryCard(),

            const SizedBox(height: 40),
            
            // 5. Secure SSL Encryption Tag
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 14, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('SECURE SSL ENCRYPTION ENABLED', 
                    style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. Support Assistance Box
            const _SupportAssistanceBox(),
            
            const SizedBox(height: 60),
            // Footer Brand & Rights
            const _CheckoutFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: const Text('Change', style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}

*/

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CheckoutBloc>()..add(LoadCheckoutEvent()),
      child: const _CheckoutView(),
    );
  }
}


class _PaymentMethodTabs extends StatefulWidget {
  const _PaymentMethodTabs();

  @override
  State<_PaymentMethodTabs> createState() => _PaymentMethodTabsState();
}

class _PaymentMethodTabsState extends State<_PaymentMethodTabs> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab(0, 'Credit Card')),
          Expanded(child: _buildTab(1, 'Digital Wallet')),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] 
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _CreditCardForm extends StatelessWidget {
  const _CreditCardForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildTextField('CARD NUMBER', '0000 0000 0000 0000', Icons.credit_card),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('EXPIRY DATE', 'MM / YY', null)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('CVV', '•••', Icons.help_outline)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Switch(
                value: true, 
                onChanged: (v) {}, 
                activeThumbColor: const Color(0xFF004D7A),
              ),
              const Text('Save card for future purchases', 
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          // Apple/Google Pay Shortcut
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, size: 18),
                const SizedBox(width: 8),
                RichText(text: const TextSpan(
                  children: [
                    TextSpan(text: 'Google', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Pay', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ]
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFCBD5E0)),
            suffixIcon: icon != null ? Icon(icon, color: const Color(0xFFCBD5E0), size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class _DeliveryMethodSelector extends StatefulWidget {
  const _DeliveryMethodSelector();

  @override
  State<_DeliveryMethodSelector> createState() => _DeliveryMethodSelectorState();
}

class _DeliveryMethodSelectorState extends State<_DeliveryMethodSelector> {
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMethodItem(0, 'Standard Shipping', '4-7 business days', 'Free'),
        const SizedBox(height: 12),
        _buildMethodItem(1, 'Express Delivery', 'Next business day', '\$45.00'),
      ],
    );
  }

  Widget _buildMethodItem(int index, String title, String time, String price) {
    bool isSelected = selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: const Color(0xFF004D7A), width: 2) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
              color: isSelected ? const Color(0xFF004D7A) : Colors.grey),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            Text(price, style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: price == 'Free' ? Colors.green : Colors.black,
            )),
          ],
        ),
      ),
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('AQUA ARTISAN', 
          style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FooterLink('PRIVACY\nPOLICY'),
            _FooterLink('TERMS OF\nSERVICE'),
            _FooterLink('SHIPPING\nGUIDE'),
          ],
        ),
        const SizedBox(height: 24),
        Text('© 2024 Aqua Artisan. All architectural rights reserved.', 
          style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
    );
  }
}


class _ShippingAddressCard extends StatelessWidget {
  const _ShippingAddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.location_on, color: Color(0xFF004D7A)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Julianne Sterling', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('4822 Highland View Terrace, Suite 402\nArchitectural District, Seattle, WA 98101',
                  style: TextStyle(color: Colors.black54, height: 1.4)),
                SizedBox(height: 8),
                Text('+1 (555) 902-4822', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Product Item 1
          _buildProductRow('Aura Curve Faucet', 'Matte Black / Professional', '849.00', 'assets/images/faucet.png'),
          const Divider(height: 32),
          // Product Item 2
          _buildProductRow('Zenith Basin', 'Stone Grey / Medium', '1,250.00', 'assets/images/basin.png'),
          const SizedBox(height: 32),
          
          // Price Details
          _buildPriceRow('Subtotal', '\$2,099.00'),
          _buildPriceRow('Shipping', 'FREE', isGreen: true),
          _buildPriceRow('Estimated Tax', '\$167.92'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(thickness: 1),
          ),
          _buildPriceRow('Total', '\$2,266.92', isTotal: true),
          const SizedBox(height: 24),
          
          // Place Order Button (Gradient)
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [Color(0xFFC04000), Color(0xFFFF7F50)]),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
              child: const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(String name, String desc, String price, String img) {
    return Row(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.water_drop_outlined, color: Colors.grey), // Placeholder
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text('\$$price', style: const TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isGreen = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 22 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontSize: isTotal ? 22 : 14, fontWeight: FontWeight.bold, color: isGreen ? Colors.green : (isTotal ? Colors.black : Colors.black87))),
        ],
      ),
    );
  }
}

class _SupportAssistanceBox extends StatelessWidget {
  const _SupportAssistanceBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF004D7A).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: Color(0xFF004D7A), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Need assistance?', style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Our concierge plumbing experts are available 24/7 for technical specs or installation advice.',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CHAT WITH AN ARTISAN', style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold, fontSize: 12)),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF004D7A)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            // Navigate to success page
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_)=> OrderSuccessPage(confirmation: 
              
             state.confirmation
            )));
            // Navigator.pushNamed(context,
            //   RouteNames.orderConfirmation,
            //   // pathParameters: {'id': ''},
            //   // extra: state.confirmation,
            // );
          }

          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CheckoutReady) {
            return _CheckoutContent(state: state);
          }

          if (state is CheckoutProcessingPayment) {
            return _ProcessingPaymentView(summary: state.orderSummary);
          }

          if (state is CheckoutPlacingOrder) {
            return _PlacingOrderView(summary: state.orderSummary);
          }

          if (state is CheckoutError) {
            return _ErrorView(message: state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Checkout Content (Main View)
// ═══════════════════════════════════════════════════════════════════

class _CheckoutContent extends StatelessWidget {
  final CheckoutReady state;

  const _CheckoutContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
  var checkout = Provider.of<CheckoutProvider>(context); 
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: spacing.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacing.verticalMD,

                // ── Shipping Address ─────────────────────────────
                const _SectionHeader(title: 'Shipping Address'),
                spacing.verticalSM,
                AddressSelector(
                  addresses: state.addresses!,
                  selectedAddress: state.selectedAddress,
                  onSelectAddress: (addr) => context
                      .read<CheckoutBloc>()
                      .add(SelectShippingAddressEvent(addr)),
                  onAddNew: () => _showAddAddressSheet(context),
                ),

                spacing.verticalLG,

                // ── Payment Method ───────────────────────────────
                const _SectionHeader(title: 'Payment Method'),
                spacing.verticalSM,
                PaymentMethodSelector(
                  selectedMethod: state.selectedPaymentMethod,
                  onSelectMethod: (method) => context
                      .read<CheckoutBloc>()
                      .add(SelectPaymentMethodEvent(method)),
                ),

                spacing.verticalLG,

                // ── Order Notes ──────────────────────────────────
                const _SectionHeader(title: 'Order Notes (Optional)'),
                spacing.verticalSM,
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add any special instructions...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          context.shapes.borderRadiusSmall),
                    ),
                  ),
                  onChanged: (text) => context
                      .read<CheckoutBloc>()
                      .add(UpdateOrderNotesEvent(text)),
                ),

                spacing.verticalLG,

                // ── Order Summary ────────────────────────────────
                const _SectionHeader(title: 'Order Summary'),
                spacing.verticalSM,
                OrderSummarySection(
                  cart: state.cart,
                  shippingFee: state.shippingFee,
                  subtotal: state.subtotal,
                  tax: state.tax,
                  discount: state.discount,
                  total: state.total,
                ),

                spacing.verticalXXL,
                const _SupportAssistanceBox(), 
                 spacing.verticalXL,
                const _CheckoutFooter()
              ],
            ),
          ),
        ),

        // ── Place Order Button ───────────────────────────────
        _PlaceOrderButton(canPlace: state.canPlaceOrder),

      
      ],
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, sc) => Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const AddAddressSheet(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Processing Payment View
// ═══════════════════════════════════════════════════════════════════

class _ProcessingPaymentView extends StatelessWidget {
  final OrderSummary summary;

  const _ProcessingPaymentView({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Processing Payment...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we process your payment',
              style: TextStyle(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Placing Order View
// ═══════════════════════════════════════════════════════════════════

class _PlacingOrderView extends StatelessWidget {
  final OrderSummary summary;

  const _PlacingOrderView({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Placing Your Order...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Almost there! Creating your order',
              style: TextStyle(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Error View
// ═══════════════════════════════════════════════════════════════════

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.error),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Place Order Button
// ═══════════════════════════════════════════════════════════════════

class _PlaceOrderButton extends StatelessWidget {
  final bool canPlace;

  const _PlaceOrderButton({required this.canPlace});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final shapes = context.shapes;

    return Container(
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
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: canPlace
              ? () => context.read<CheckoutBloc>().add(PlaceOrderEvent())
              : null,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
            ),
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Section Header
// ═══════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Add Address Sheet (Simplified - full implementation in widgets file)
// ═══════════════════════════════════════════════════════════════════
class CountryData {
  final int id;
  final String nameEn;
  final String nameAr;
  final String prefix;
  final int digitCount; // For validation

  CountryData({
    required this.id, 
    required this.nameEn, 
    required this.nameAr, 
    required this.prefix, 
    this.digitCount = 9
  });
}

// Global/Static data for the dropdowns
final List<CountryData> appCountries = [
  CountryData(id: 188, nameEn: "Saudi Arabia", nameAr: "المملكة العربية السعودية", prefix: "+966"),
  CountryData(id: 1, nameEn: "United Arab Emirates", nameAr: "الإمارات العربية المتحدة", prefix: "+971"),
  CountryData(id: 10, nameEn: "Egypt", nameAr: "مصر", prefix: "+20"),
];
class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
final _formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final _streetController = TextEditingController();
  final _street2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _dialCode ='+966';
  final _mobileController = TextEditingController();
late CountryData _selectedCountry;
  // Dropdown Values (Integers for Odoo)
  final int _selectedCountryId = 188; // Default to Saudi Arabia
  int? _selectedStateId;

  // Mock Data (In a real app, fetch these from your AddressBloc/Repository)
  final List<Map<String, dynamic>> _countries = [
    {'id': 188, 'name': 'Saudi Arabia'},
    {'id': 1, 'name': 'United Arab Emirates'},
  ];

  final List<Map<String, dynamic>> _states = [
    {'id': 1251, 'name': 'Makkah'},
    {'id': 1252, 'name': 'Riyadh'},
    {'id': 1253, 'name': 'Jeddah'},
  ];

  void _submit() {
    if (_formKey.currentState!.validate() ) {
      final data = {
        'id':0,
        "street": _streetController.text,
        "street2": _street2Controller.text,
        "city": _cityController.text,
        "state_id": context.read<CheckoutProvider>().selectedState!.id.toString(),
        "zip": _zipController.text,
        "country_id": context.read<CheckoutProvider>().selectedCountry!.id.toString(),
        "phone":_dialCode!+ _phoneController.text,
        "mobile":_dialCode!+ _mobileController.text,


   
      };

      log(data.toString());
      context.read<CheckoutProvider>().saveAddress(ShippingAddressModel.fromJson(data).toEntity());
      // Return the map or convert to ShippingAddress entity
      Navigator.pop(context, data);
    }
  }

  @override
  void initState() {
    super.initState();
   

    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<CheckoutProvider>().fetchCountries().then((_){
if (mounted) {
  _dialCode = "+${context.read<CheckoutProvider>().countries.first.phoneCode}";
  setState(() {
    
  });
}

      });
    });
  }
void _onCountryChanged(CountryData? country) {
    if (country == null) return;
    setState(() {
      _selectedCountry = country;
      // Update prefix but keep current input if user already typed
      _phoneController.text = country.prefix;
      _mobileController.text = country.prefix;
    });
  }
  @override
  Widget build(BuildContext context) {
    var checkout = Provider.of<CheckoutProvider>(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Shipping Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
                // Country Dropdown
             // Country Dropdown
              DropdownButtonFormField<CountryModel>(
                initialValue: checkout.selectedCountry,
                decoration: const InputDecoration(labelText: true ? "الدولة" : "Country"),
                items: checkout.countries.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(true ? c.name : c.name),
                )).toList(),
                onChanged: (country){
      //             _phoneController.text = "+${country!.phoneCode}";
      // _mobileController.text = "+${country.phoneCode}";
      _dialCode ="+${country!.phoneCode}";
      setState(() {
        
      });
checkout.selectCountry(country);
                },
              ),
      const SizedBox(height: 15),
              // State Dropdown
              DropdownButtonFormField<CountryStateModel>(
                initialValue: checkout.selectedState,
                decoration: const InputDecoration(labelText: "State/Region"),
                items: checkout.states.map((s) => DropdownMenuItem<CountryStateModel>(
                  value: s, child: Text(s.name))).toList(),
                onChanged: (val){
                  checkout.selectState(val);
                },
                validator: (v) => v == null ? 'Please select a state' : null,
              ),
      const SizedBox(height: 15),

              // Standard TextFields
              _buildField(_streetController, "Street"),
              _buildField(_street2Controller, "Apartment/Suite (Optional)"),
              _buildField(_cityController, "City"),
              _buildField(_zipController, "Zip Code", keyboard: TextInputType.number),

            
              _buildField(_phoneController, "Phone", keyboard: TextInputType.phone ,prefix: _dialCode),
              _buildField(_mobileController, "Mobile", keyboard: TextInputType.phone ,prefix: _dialCode),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Save Address"),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType? keyboard , String? prefix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()
         , prefix: prefix!=null? Text(prefix):null
        
        ),
        keyboardType: keyboard,

        validator: (v) => v!.isEmpty && !label.contains('Optional') ? 'Required' : null,
      ),
    );
  }
}