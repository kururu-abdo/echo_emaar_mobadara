import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error, info }

class AppToast extends StatelessWidget {
  final String message;
  final ToastType type;

  const AppToast({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //
    
    // Determine color based on type from your brand config
    final Color statusColor = type == ToastType.success 
        ? colors.success 
        : type == ToastType.error 
            ? colors.error 
            : colors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.9), // Glass effect
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusMedium),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == ToastType.success ? Icons.check_circle_rounded : Icons.error_rounded,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ToastUtils {
  static void show(BuildContext context, String message, {ToastType type = ToastType.success}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Top-down modern Google style
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: AppToast(message: message, type: type),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}