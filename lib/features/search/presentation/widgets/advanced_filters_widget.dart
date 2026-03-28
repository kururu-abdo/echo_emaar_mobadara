// lib/features/search/presentation/widgets/advanced_filters_widget.dart
import 'package:echoemaar_commerce/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvancedFiltersWidget extends StatelessWidget {
  const AdvancedFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SearchProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () {}, child: const Text('مسح الكل', style: TextStyle(color: Colors.blue))),
              const Text('الفلاتر المتقدمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // قائمة الفئات الأفقية
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // للعربية
          child: Row(
            children: [
              _buildFilterChip('الكل', true),
              _buildFilterChip('صنابير', false),
              _buildFilterChip('دش استحمام', false),
              _buildFilterChip('أحواض', false),
            ],
          ),
        ),SizedBox(height: 24,),
_buildPriceRangeFilter(provider),

        SizedBox(height: 24,),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('اللون واللمسة النهائية', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
              _buildDynamicColorFilter(provider)

      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF7F50) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }


// داخل ملف advanced_filters_widget.dart
Widget _buildPriceRangeFilter(SearchProvider provider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${provider.priceRange.start.round()} - ${provider.priceRange.end.round()} ر.س',
              style: const TextStyle(color: Color(0xFF1D71A4), fontWeight: FontWeight.bold),
            ),
            const Text('نطاق السعر', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: provider.priceRange,
          min: 500,
          max: 4500,
          divisions: 40,
          activeColor: const Color(0xFF1D71A4),
          inactiveColor: Colors.black12,
          labels: RangeLabels(
            provider.priceRange.start.round().toString(),
            provider.priceRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            provider.updatePriceRange(values);
          },
        ),
      ],
    ),
  );
}
  // جزء من ملف advanced_filters_widget.dart
// داخل ملف advanced_filters_widget.dart
Widget _buildDynamicColorFilter(SearchProvider provider) {
  final List<Map<String, dynamic>> colors = [
    {'name': 'كروم', 'color': Colors.blueGrey.shade100},
    {'name': 'أسود مطفي', 'color': const Color(0xFF4A5568)},
    {'name': 'ذهبي', 'color': const Color(0xFFECC94B)},
    {'name': 'نيكل', 'color': const Color(0xFFCBD5E0)},
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: colors.map((c) {
      final bool isSelected = provider.selectedColor == c['name'];
      return GestureDetector(
        onTap: () => provider.updateColor(c['name']),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected 
                    ? Border.all(color: const Color(0xFF1D71A4), width: 2) 
                    : Border.all(color: Colors.transparent),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: c['color'],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              c['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF1D71A4) : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}


}

class _ColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  const _ColorOption({required this.color, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: const Color(0xFF004D7A), width: 2) : null,
          ),
          child: CircleAvatar(radius: 20, backgroundColor: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }



}