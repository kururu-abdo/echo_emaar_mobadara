import 'package:flutter/material.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner.png'), // صورة الصنابير الإيطالية
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20, right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('جديد', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const Text('مجموعة الصنابير الإيطالية الحديثة', 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('تبدأ من 1,200 ر.س', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D7A)),
                  child: const Text('تسوق الآن'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}