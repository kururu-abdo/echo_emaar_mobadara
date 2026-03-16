import 'package:echoemaar_commerce/core/utilities/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../config/themes/brand_config.dart';

class AppSpacing {
  final BrandSpacing brandSpacing;
  
  AppSpacing(this.brandSpacing);
  
  // Spacing values
  double get xs => brandSpacing.xs;
  double get sm => brandSpacing.sm;
  double get md => brandSpacing.md;
  double get lg => brandSpacing.lg;
  double get xl => brandSpacing.xl;
  double get xxl => brandSpacing.xxl;
  
  // Vertical spacing widgets
  Widget get verticalXS => SizedBox(height: xs);
  Widget get verticalSM => SizedBox(height: sm);
  Widget get verticalMD => SizedBox(height: md);
  Widget get verticalLG => SizedBox(height: lg);
  Widget get verticalXL => SizedBox(height: xl);
  Widget get verticalXXL => SizedBox(height: xxl);
  
  // Horizontal spacing widgets
  Widget get horizontalXS => SizedBox(width: xs);
  Widget get horizontalSM => SizedBox(width: sm);
  Widget get horizontalMD => SizedBox(width: md);
  Widget get horizontalLG => SizedBox(width: lg);
  Widget get horizontalXL => SizedBox(width: xl);
  Widget get horizontalXXL => SizedBox(width: xxl);
  
  // Edge Insets
  EdgeInsets get paddingXS => EdgeInsets.all(xs);
  EdgeInsets get paddingSM => EdgeInsets.all(sm);
  EdgeInsets get paddingMD => EdgeInsets.all(md);
  EdgeInsets get paddingLG => EdgeInsets.all(lg);
  EdgeInsets get paddingXL => EdgeInsets.all(xl);
  EdgeInsets get paddingXXL => EdgeInsets.all(xxl);
  
  EdgeInsets get paddingHorizontalXS => EdgeInsets.symmetric(horizontal: xs);
  EdgeInsets get paddingHorizontalSM => EdgeInsets.symmetric(horizontal: sm);
  EdgeInsets get paddingHorizontalMD => EdgeInsets.symmetric(horizontal: md);
  EdgeInsets get paddingHorizontalLG => EdgeInsets.symmetric(horizontal: lg);
  EdgeInsets get paddingHorizontalXL => EdgeInsets.symmetric(horizontal: xl);
  
  EdgeInsets get paddingVerticalXS => EdgeInsets.symmetric(vertical: xs);
  EdgeInsets get paddingVerticalSM => EdgeInsets.symmetric(vertical: sm);
  EdgeInsets get paddingVerticalMD => EdgeInsets.symmetric(vertical: md);
  EdgeInsets get paddingVerticalLG => EdgeInsets.symmetric(vertical: lg);
  EdgeInsets get paddingVerticalXL => EdgeInsets.symmetric(vertical: xl);
  
  // Page padding (responsive)
  EdgeInsets pagePadding(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) return paddingMD;
    if (ResponsiveUtils.isTablet(context)) return paddingLG;
    return paddingXL;
  }
  
  EdgeInsets pageHorizontalPadding(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) return paddingHorizontalMD;
    if (ResponsiveUtils.isTablet(context)) return paddingHorizontalLG;
    return paddingHorizontalXL;
  }
}

// Global spacing access
class Spacing {
  static Widget vertical(double height) => SizedBox(height: height);
  static Widget horizontal(double width) => SizedBox(width: width);
  
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }
}