import 'package:echoemaar_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/pages/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  String _state = 'loading'; // الحالات: 'loading', 'loaded', 'error'

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _state = 'loaded');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Saved Addresses', 
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
      ),
      body: _buildBodyByState(),
      floatingActionButton: _state == 'loaded' ? FloatingActionButton.extended(
        onPressed: () {

                                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const AddAddressPage()));

        }, // فتح نافذة إضافة عنوان جديد
        backgroundColor: const Color(0xFF004D7A),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Address', style: TextStyle(color: Colors.white)),
      ) : null,
    );
  }

  Widget _buildBodyByState() {
    if (_state == 'loading') return _buildShimmerLoading();
    if (_state == 'error') return _buildErrorView();
    return _buildAddressesList();
  }

  // 1. حالة التحميل (Loading with Shimmer)
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 120,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
          const Icon(Icons.location_off_outlined, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text('Failed to load addresses', style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(onPressed: () => setState(() => _state = 'loading'), child: const Text('Retry')),
        ],
      ),
    );
  }

  // 3. حالة النجاح (Loaded List)
  Widget _buildAddressesList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildAddressCard(
          title: 'Home',
          address: '4822 Highland View Terrace, Suite 402, Seattle, WA 98101',
          phone: '+1 (555) 902-4822',
          isDefault: true,
        ),
        const SizedBox(height: 16),
        _buildAddressCard(
          title: 'Office',
          address: 'Architectural District, Building 7, Floor 12, Seattle, WA 98104',
          phone: '+1 (555) 123-4567',
          isDefault: false,
        ),
      ],
    );
  }

  Widget _buildAddressCard({
    required String title,
    required String address,
    required String phone,
    bool isDefault = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDefault ? Border.all(color: const Color(0xFF004D7A), width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: isDefault ? const Color(0xFF004D7A) : Colors.grey),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (isDefault) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(4)),
                      child: const Text('DEFAULT', style: TextStyle(color: Color(0xFF004D7A), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(address, style: const TextStyle(color: Colors.black54, height: 1.4)),
          const SizedBox(height: 8),
          Text(phone, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}