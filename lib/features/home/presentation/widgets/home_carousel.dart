import 'package:cached_network_image/cached_network_image.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
// Import your AppButton here

class HeroCarousel extends StatefulWidget {
  final double height;

  const HeroCarousel({
    super.key,
    this.height = 400.0, // Standard hero height, adjust as needed
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Placeholder data - you can replace this with your actual models later
  final List<Map<String, String>> _slides = [
    {
      'title': 'كل ما يحتاجه مشروعك في\nمكان واحد',
      'buttonText': 'اطلب عرض سعر',
      'image':'https://echoemaar.com/web/image/58519-7a30886f/slider1.jpg'
    },
    {
      'title': 'أطقم صحية فاخرة\nبتصاميم عصرية',
      'buttonText': 'تصفح المنتجات',
            'image':'https://echoemaar.com/web/image/58520-e6215b5a/slider2.jpg'

    },
    {
      'title': 'جودة استثنائية\nتليق بمساحتك',
      'buttonText': 'اكتشف المزيد',
            'image':'https://echoemaar.com/web/image/58521-f373a029/slider3.jpg'

    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. The Swiping Pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return HeroSlide(
                title: _slides[index]['title']!,
                buttonText: _slides[index]['buttonText']!,
                image: _slides[index]['image']!,
              );
            },
          ),

          // 2. Custom Pagination Indicators
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  // The active dot is a wider pill, inactive are small circles
                  width: _currentPage == index ? 24 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? colors.primaryLight // Use your blue brand color
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class HeroSlide extends StatelessWidget {
  final String title;
  final String buttonText;
  final String  image;

  const HeroSlide({
    super.key,
    required this.title,
    required this.buttonText, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //
    final shapes = context.shapes; //

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background Image Placeholder
        Container(
          // color: Colors.grey[800], // Placeholder for Image.asset or CachedNetworkImage
          decoration: BoxDecoration(
            image: DecorationImage(image: CachedNetworkImageProvider(image), fit: BoxFit.fill), 

          
          ),
          child: const Center(
            child: Icon(Icons.image, color: Colors.white24, size: 64),
          ),
        
        ),
        
        // Dark overlay to ensure text readability on bright images
        Container(
          color: Colors.black.withOpacity(0.2),
        ),

        // 2. Floating Content Card (Aligned to Right for Arabic)
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(shapes.borderRadiusLarge), //
                  // Outer crisp border matching your screenshot
                  border: Border.all(
                    color: colors.primaryLight.withOpacity(0.4), 
                    width: 1.5,
                  ),
                  // The layered dark gradient
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      const Color(0xFF162D45).withOpacity(0.9),
                      const Color(0xFF0C1E30).withOpacity(0.95),
                      const Color(0xFF081525),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end, // Align text to right
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: context.textTheme.displaySmall?.copyWith( //
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // The AppButton we built previously
                    AppButton(
                      label: buttonText,
                      width: 180, // Constrain width so it doesn't span the whole card
                      onTap: () {
                        // Handle quote request
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}