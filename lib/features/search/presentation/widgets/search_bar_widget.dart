// lib/features/search/presentation/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن المنتجات، الماركات، أو الفئات...',
          hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF004D7A)),
          suffixIcon: const Icon(Icons.close, color: Colors.grey, size: 20),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}