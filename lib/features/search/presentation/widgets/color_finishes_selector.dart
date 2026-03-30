import 'package:flutter/material.dart';

class ColorFinishesSelector extends StatelessWidget {
  const ColorFinishesSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      {'name': 'كروم', 'color': const Color(0xFFD9E2EC), 'selected': true},
      {'name': 'أسود مطفي', 'color': const Color(0xFF486581), 'selected': false},
      {'name': 'ذهبي', 'color': const Color(0xFFF0D288), 'selected': false},
      {'name': 'نيكل', 'color': const Color(0xFFBCCCDC), 'selected': false},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((c) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: c['selected'] == true ? Border.all(color: const Color(0xFF004D7A), width: 2) : null,
            ),
            child: CircleAvatar(radius: 22, backgroundColor: c['color'] as Color),
          ),
          const SizedBox(height: 8),
          Text(c['name'] as String, 
            style: TextStyle(fontSize: 12, fontWeight: c['selected'] == true ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF004D7A))),
        ],
      )).toList(),
    );
  }
}