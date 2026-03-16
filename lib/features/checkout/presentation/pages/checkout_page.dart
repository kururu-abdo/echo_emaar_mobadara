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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/checkout_bloc.dart';
import '../widgets/address_selector.dart';
import '../widgets/payment_method_selector.dart';

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