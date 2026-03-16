import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;
  final bool showFilterButton;
  final int? filterCount;
  
  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search products...',
    this.showFilterButton = true,
    this.filterCount,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            child: Icon(
              Icons.search,
              color: context.colors.textSecondary,
            ),
          ),
          
          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyles.bodyMedium(context),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: context.colors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          
          // Clear Button
          if (controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: context.colors.textSecondary,
              ),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            ),
          
          // Filter Button
          if (showFilterButton && onFilterTap != null) ...[
            Container(
              width: 1,
              height: 30,
              color: context.colors.divider,
              margin: EdgeInsets.symmetric(horizontal: context.spacing.xs),
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: context.colors.primary,
                  ),
                  onPressed: onFilterTap,
                ),
                if (filterCount != null && filterCount! > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$filterCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}