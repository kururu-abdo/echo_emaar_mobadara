// lib/features/search/presentation/widgets/price_range_slider.dart
import 'package:flutter/material.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues _currentRange = const RangeValues(500, 4500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentRange.start.round()} - ${_currentRange.end.round()} ر.س',
                style: const TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold),
              ),
              const Text('نطاق السعر', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: _currentRange,
            min: 500,
            max: 4500,
            divisions: 40,
            activeColor: const Color(0xFF004D7A),
            inactiveColor: const Color(0xFFD9E2EC),
            labels: RangeLabels(
              _currentRange.start.round().toString(),
              _currentRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRange = values;
              });
            },
          ),
        ],
      ),
    );
  }
}