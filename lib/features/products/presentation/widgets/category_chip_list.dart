import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryChipList extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;
  
  const CategoryChipList({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: context.spacing.paddingHorizontalMD,
        children: [
          // All Products Chip
          _CategoryChip(
            label: 'All',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          
          SizedBox(width: context.spacing.sm),
          
          // // Category Chips
          // ...categories.map(
          //   (category) => Padding(
          //     padding: EdgeInsets.only(right: context.spacing.sm),
          //     child: _CategoryChip(
          //       label: category.name,
          //       productCount: category.productCount,
          //       isSelected: selectedCategoryId == category.id,
          //       onTap: () => onCategorySelected(category.id),
          //     ),
            // ),
          // ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final int? productCount;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _CategoryChip({
    required this.label,
    this.productCount,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(context.shapes.borderRadiusLarge),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyles.bodySmall(context).copyWith(
                color: isSelected
                    ? Colors.white
                    : context.colors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (productCount != null) ...[
              SizedBox(width: context.spacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : context.colors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$productCount',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : context.colors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}