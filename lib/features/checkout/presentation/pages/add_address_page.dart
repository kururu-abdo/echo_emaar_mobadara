import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/providers/checkout_provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  String _state = 'loading'; // الحالات: 'loading', 'loaded', 'error'

  // Controllers
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRequiredData();
  }

  void _fetchRequiredData() async {
    // محاكاة جلب الدول والولايات من الـ Provider/API
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _state = 'loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF004D7A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Shipping Address', 
          style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
      ),
      body: _buildBodyByState(),
      bottomNavigationBar: _state == 'loaded' ? _buildSaveButton() : null,
    );
  }

  Widget _buildBodyByState() {
    if (_state == 'loading') return _buildShimmerLoading();
    if (_state == 'error') return _buildErrorView();
    return _buildAddressForm();
  }

  // 1. حالة التحميل (Loading with Shimmer)
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        itemBuilder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 15, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 2. حالة الخطأ (Error View)
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_outlined, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text('Unable to load location data'),
          TextButton(onPressed: () => setState(() => _state = 'loading'), child: const Text('Retry')),
        ],
      ),
    );
  }

  // 3. حالة النجاح (Loaded Form)
  Widget _buildAddressForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('FULL NAME'),
            AuthInputField(controller: _nameController, hintText: 'Receiver Name', suffixIcon: Icons.person_outline),
            
            const SizedBox(height: 20),
            
            _buildLabel('STREET ADDRESS'),
            AuthInputField(controller: _streetController, hintText: 'House No, Street Name', suffixIcon: Icons.location_on_outlined),

            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('CITY'),
                      AuthInputField(controller: _cityController, hintText: 'City'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('ZIP CODE'),
                      AuthInputField(controller: _zipController, hintText: '00000', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildLabel('PHONE NUMBER'),
            AuthInputField(controller: _phoneController, hintText: '5X XXX XXXX', suffixIcon: Icons.phone_android, keyboardType: TextInputType.phone),

            const SizedBox(height: 20),

            // Toggle for Default Address
            Row(
              children: [
                Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFF004D7A)),
                const Text('Set as default shipping address', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: [Color(0xFFC04000), Color(0xFFFF7F50)]),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // منطق الحفظ وربطه بالـ Provider
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
          child: const Text('Save Address', 
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}