import 'package:flutter/material.dart';

class ProductVisualArea extends StatelessWidget {
  final String imageUrl;
  final String productId;
  final bool isFavorite;

  const ProductVisualArea({
    super.key,
    required this.imageUrl,
    required this.productId,
    this.isFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    // We use a fixed height for the image area to keep cards uniform
    return SizedBox(
      height: 200, 
      child: Stack( // 🥞 The Stack allows us to layer widgets
        children: [
          // 1. Base Layer: The Product Image
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              // Placeholder for the actual image
              child: Icon(Icons.shower, size: 100, color: Colors.grey[400]), 
            ),
          ),

          // 2. Top Left: Favorite Button
          Positioned( // 📍 Pins the widget 12 pixels from top and left
            top: 12,
            left: 12,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF3B82F6), // Blue background
              radius: 18,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: const Color(0xFFFBBF24), // Yellow star
                size: 20,
              ),
            ),
          ),

          // 3. Top Right: Brand Logo
          const Positioned(
            top: 12,
            right: 12,
            child: Text(
              'ORISA', // Replace with an Image.asset for the actual logo
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // 4. Bottom Left: ID Badge
          Positioned(
            bottom: 0, // Aligned flush to the bottom
            left: 0,   // Aligned flush to the left
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF4B5563), // Dark grey
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                'ID : $productId',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}