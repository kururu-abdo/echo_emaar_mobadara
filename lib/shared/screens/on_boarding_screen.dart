import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
// import 'widgets/app_button.dart'; // Your custom button

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "جودة استثنائية\nلمشاريعك",
      subtitle: "نقدم لك أفضل حلول السباكة والأدوات الصحية من أرقى العلامات التجارية العالمية.",
      image: "assets/images/onboarding1.png",
    ),
    OnboardingData(
      title: "تصاميم عصرية\nتناسب ذوقك",
      subtitle: "اكتشف تشكيلة واسعة من الخلاطات والأطقم الصحية التي تجمع بين الأناقة والوظيفة.",
      image: "assets/images/onboarding2.png",
    ),
    OnboardingData(
      title: "تجربة تسوق\nسهلة وسريعة",
      subtitle: "اطلب كل ما تحتاجه لمشروعك بضغطة زر واحدة مع خدمة التوصيل السريع.",
      image: "assets/images/onboarding3.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //

    return Scaffold(
      body: Stack(
        children: [
          // 1. The Architectural Gradient Background we built
          _buildBackground(context),

          // 2. The Main Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
                ),
              ),

              // 3. Navigation Footer
              _buildFooter(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF162D45), Color(0xFF081525)], //
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.5),
              radius: 1.2,
              colors: [context.colors.primary.withOpacity(0.12), Colors.transparent], //
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colors = context.colors;
    bool isLastPage = _currentIndex == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Dot Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) => _buildDot(index, context)),
          ),
          const SizedBox(height: 48),
          
          // Using your custom scaling AppButton
          AppButton(
            label: isLastPage ? "ابدأ الآن" : "التالي",
            onTap: () {
              if (isLastPage) {
                // Navigate to Login/Home
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? context.colors.primaryLight : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}


class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Area with the architectural border we built
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.shapes.borderRadiusLarge),
              border: Border.all(color: context.colors.primaryLight.withOpacity(0.2)),
            ),
            child: const Center(
              child: Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.white12),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title, subtitle, image;
  OnboardingData({required this.title, required this.subtitle, required this.image});
}