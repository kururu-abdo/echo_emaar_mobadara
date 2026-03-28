// lib/features/search/presentation/widgets/recent_searches_widget.dart
import 'package:echoemaar_commerce/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // هذه البيانات تأتي عادة من Local Storage أو API
    final List<String> recentQueries = [
      'إكسسوارات حمام ذهبي',
      'حوض رخام',
      'خلاط مغسلة تركي',
    ];
var provider = Provider.of<SearchProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين (عربي)
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'عمليات البحث الأخيرة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(width: 8),
              Icon(Icons.history, color: Colors.grey.shade600, size: 20),
            ],
          ),
          const SizedBox(height: 12),
         Wrap(
  children: provider.searchHistory.map((query) => InkWell(
    onTap: () => provider.searchProducts(query), // البحث عند الضغط
    child: Chip(
      label: Text(query),
      onDeleted: () => provider.removeFromHistory(query), // الحذف من السجل
      deleteIcon: const Icon(Icons.close, size: 14),
    ),
  )).toList(),
)
        ],
      ),
    );
  }

  Widget _buildSearchTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.close, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}