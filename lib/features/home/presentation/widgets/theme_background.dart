import 'package:flutter/material.dart';

class ThemeBackground extends StatelessWidget {
  final Widget child;

  const ThemeBackground({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. The Base Linear Gradient Layer (-160deg)
      decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
// border: Border(top: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        gradient: const LinearGradient(
          begin: Alignment.topRight, 
          
          end: Alignment.bottomLeft,
          stops: [0.0, 0.5, 1.0],
          colors: [
            Color(0xFF162D45), // #162d45
            Color(0xFF0C1E30), // #0c1e30
            Color(0xFF081525), // #081525
          ],
        ),
      ),
      // 2. The Radial Glow Layer (Ellipse at 50% 20%)
      child: Container(
        decoration:  BoxDecoration(
          border: Border(top: BorderSide(width: 2, color: Theme.of(context).primaryColor)),

          borderRadius: BorderRadius.circular(8),
          gradient: const RadialGradient(
            center: Alignment(0.0, -0.6), // 50% X, 20% Y
            radius: 0.85, // Ellipse spread
            stops: [0.0, 0.65],
            colors: [
              Color.fromRGBO(29, 111, 164, 0.18), // rgba(29, 111, 164, 0.18)
              Colors.transparent,
            ],
          ),
        ),
        // 3. Your screen's actual content goes here
        child: child, 
      ),
    );
  }
}