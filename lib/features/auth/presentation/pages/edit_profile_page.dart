import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _state = 'loading'; // الحالات: 'loading', 'loaded', 'error'
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _finalPhone = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // محاكاة جلب البيانات من الـ API
  void _fetchUserData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _nameController.text = "Alex Rivers";
        _emailController.text = "alex.rivers@architect.com";
        _state = 'loaded'; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D7A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', 
          style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _buildBodyByState(),
      bottomNavigationBar: _state == 'loaded' ? _buildSaveButton() : null,
    );
  }

  Widget _buildBodyByState() {
    if (_state == 'loading') return _buildShimmerLoading();
    if (_state == 'error') return _buildErrorView();
    return _buildProfileForm();
  }

  // 1. حالة التحميل (Loading with Shimmer)
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.white),
            const SizedBox(height: 40),
            ...List.generate(3, (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 15, color: Colors.white),
                const SizedBox(height: 10),
                Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 20),
              ],
            )),
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
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text('Failed to load profile data', style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => setState(() => _state = 'loading'),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // 3. حالة النجاح (Loaded Form)
  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Edit
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFE2E8F0),
                  backgroundImage: AssetImage('assets/images/user_avatar.png'),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF004D7A), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          _buildLabel('FULL NAME'),
          AuthInputField(
            controller: _nameController,
            hintText: 'Enter your name',
            suffixIcon: Icons.person_outline,
          ),
          
          const SizedBox(height: 24),
          
          _buildLabel('EMAIL ADDRESS'),
          AuthInputField(
            controller: _emailController,
            hintText: 'example@domain.com',
            suffixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 24),

          _buildLabel('PHONE NUMBER'),
          PhoneInputField(
            controller: _phoneController,
            onFullNumberSaved: (val) => _finalPhone = val,
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
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
            // Logic to save changes
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
          child: const Text('Save Changes', 
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}