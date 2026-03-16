import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:flutter/material.dart';

class EmptyProductsWidget extends StatelessWidget {
  final String? searchQuery;
  
  const EmptyProductsWidget({
    Key? key,
    this.searchQuery,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.spacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(context.spacing.xl),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                searchQuery != null && searchQuery!.isNotEmpty
                    ? Icons.search_off
                    : Icons.inventory_2_outlined,
                size: 80,
                color: context.colors.textSecondary,
              ),
            ),
            
            context.spacing.verticalXL,
            
            // Title
            Text(
              searchQuery != null && searchQuery!.isNotEmpty
                  ? 'No products found'
                  : 'No products available',
              style: TextStyles.h3(context),
              textAlign: TextAlign.center,
            ),
            
            context.spacing.verticalSM,
            
            // Description
            Text(
              searchQuery != null && searchQuery!.isNotEmpty
                  ? 'Try adjusting your search or filters\nto find what you\'re looking for'
                  : 'Check back later for new products',
              style: TextStyles.bodyMedium(context).copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (searchQuery != null && searchQuery!.isNotEmpty) ...[
              context.spacing.verticalXL,
              OutlinedButton.icon(
                onPressed: () {
                  // Clear search
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}