import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:flutter/material.dart';

enum SortOption {
  newest,
  priceLowToHigh,
  priceHighToLow,
  popularity,
  rating,
}

class FilterBottomSheet extends StatefulWidget {
  final double? minPrice;
  final double? maxPrice;
  final SortOption? sortOption;
  final bool? inStockOnly;
  final double? minRating;
  
  const FilterBottomSheet({
    Key? key,
    this.minPrice,
    this.maxPrice,
    this.sortOption,
    this.inStockOnly,
    this.minRating,
  }) : super(key: key);
  
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _minPrice;
  late double _maxPrice;
  late SortOption? _sortOption;
  late bool _inStockOnly;
  late double _minRating;
  
  final double _absoluteMinPrice = 0;
  final double _absoluteMaxPrice = 1000;
  
  @override
  void initState() {
    super.initState();
    _minPrice = widget.minPrice ?? _absoluteMinPrice;
    _maxPrice = widget.maxPrice ?? _absoluteMaxPrice;
    _sortOption = widget.sortOption;
    _inStockOnly = widget.inStockOnly ?? false;
    _minRating = widget.minRating ?? 0;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.shapes.borderRadiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: context.spacing.md),
            decoration: BoxDecoration(
              color: context.colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: context.spacing.paddingHorizontalMD,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyles.h4(context),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          Expanded(
            child: ListView(
              padding: context.spacing.pagePadding(context),
              children: [
                // Sort By
                _buildSectionTitle(context, 'Sort By'),
                context.spacing.verticalSM,
                _buildSortOptions(context),
                
                context.spacing.verticalLG,
                
                // Price Range
                _buildSectionTitle(context, 'Price Range'),
                context.spacing.verticalSM,
                _buildPriceRange(context),
                
                context.spacing.verticalLG,
                
                // Rating
                _buildSectionTitle(context, 'Minimum Rating'),
                context.spacing.verticalSM,
                _buildRatingFilter(context),
                
                context.spacing.verticalLG,
                
                // Stock
                _buildSectionTitle(context, 'Availability'),
                context.spacing.verticalSM,
                _buildStockFilter(context),
                
                context.spacing.verticalXL,
              ],
            ),
          ),
          
          // Apply Button
          Container(
            padding: context.spacing.pagePadding(context),
            decoration: BoxDecoration(
              color: context.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: context.buttonHeight(),
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply Filters'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyles.bodyMedium(context).copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  Widget _buildSortOptions(BuildContext context) {
    return Column(
      children: [
        _buildSortOption(
          context,
          'Newest First',
          SortOption.newest,
          Icons.access_time,
        ),
        _buildSortOption(
          context,
          'Price: Low to High',
          SortOption.priceLowToHigh,
          Icons.arrow_upward,
        ),
        _buildSortOption(
          context,
          'Price: High to Low',
          SortOption.priceHighToLow,
          Icons.arrow_downward,
        ),
        _buildSortOption(
          context,
          'Most Popular',
          SortOption.popularity,
          Icons.trending_up,
        ),
        _buildSortOption(
          context,
          'Highest Rated',
          SortOption.rating,
          Icons.star,
        ),
      ],
    );
  }
  
  Widget _buildSortOption(
    BuildContext context,
    String label,
    SortOption option,
    IconData icon,
  ) {
    final isSelected = _sortOption == option;
    
    return InkWell(
      onTap: () => setState(() => _sortOption = option),
      child: Container(
        padding: context.spacing.paddingMD,
        margin: EdgeInsets.only(bottom: context.spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withOpacity(0.1)
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.colors.primary
                  : context.colors.textSecondary,
              size: 20,
            ),
            SizedBox(width: context.spacing.md),
            Expanded(
              child: Text(
                label,
                style: TextStyles.bodyMedium(context).copyWith(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriceRange(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_minPrice.toStringAsFixed(0)}',
              style: TextStyles.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
            Text(
              '\$${_maxPrice.toStringAsFixed(0)}',
              style: TextStyles.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: _absoluteMinPrice,
          max: _absoluteMaxPrice,
          divisions: 100,
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildRatingFilter(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final rating = 5 - index;
        final isSelected = _minRating >= rating;
        
        return InkWell(
          onTap: () => setState(() => _minRating = rating.toDouble()),
          child: Container(
            padding: context.spacing.paddingMD,
            margin: EdgeInsets.only(bottom: context.spacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.primary.withOpacity(0.1)
                  : context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
              border: Border.all(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.border,
              ),
            ),
            child: Row(
              children: [
                ...List.generate(
                  rating,
                  (i) => Icon(Icons.star, color: Colors.amber, size: 18),
                ),
                ...List.generate(
                  5 - rating,
                  (i) => Icon(Icons.star_border, color: Colors.grey, size: 18),
                ),
                SizedBox(width: context.spacing.sm),
                Text(
                  '& Up',
                  style: TextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildStockFilter(BuildContext context) {
    return SwitchListTile(
      value: _inStockOnly,
      onChanged: (value) => setState(() => _inStockOnly = value),
      title: Text('Show in-stock items only'),
      contentPadding: EdgeInsets.zero,
      activeColor: context.colors.primary,
    );
  }
  
  void _resetFilters() {
    setState(() {
      _minPrice = _absoluteMinPrice;
      _maxPrice = _absoluteMaxPrice;
      _sortOption = null;
      _inStockOnly = false;
      _minRating = 0;
    });
  }
  
  void _applyFilters() {
    Navigator.of(context).pop({
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
      'sortOption': _sortOption,
      'inStockOnly': _inStockOnly,
      'minRating': _minRating,
    });
  }
}