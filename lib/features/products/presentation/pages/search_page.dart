// ═══════════════════════════════════════════════════════════════════
// PART 6: SEARCH PAGE UI
// ═══════════════════════════════════════════════════════════════════

// ── File: features/products/presentation/pages/search_page.dart ──

import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/search/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SearchBloc>()..add(LoadSearchHistory()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showAutocomplete = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _SearchBar(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: (query) {
            setState(() => _showAutocomplete = query.isNotEmpty);
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
          onSubmitted: (query) {
            setState(() => _showAutocomplete = false);
            _focusNode.unfocus();
            context.read<SearchBloc>().add(SearchSubmitted(query));
          },
          onClear: () {
            _searchController.clear();
            setState(() => _showAutocomplete = false);
            context.read<SearchBloc>().add(LoadSearchHistory());
          },
        ),
        actions: [
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoaded && state.hasFilters) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list_rounded,
                          color: colors.primary),
                      onPressed: () => _showFiltersSheet(context, state),
                    ),
                    if (state.activeFiltersCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${state.activeFiltersCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }
              return IconButton(
                icon: Icon(Icons.filter_list_rounded, color: colors.textSecondary),
                onPressed: () {
                  if (state is SearchLoaded) {
                    _showFiltersSheet(context, state);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          // Autocomplete overlay
          if (_showAutocomplete && state is SearchHistoryLoaded) {
            return _AutocompleteOverlay(
              history: state.history,
              query: _searchController.text,
              onSelect: (query) {
                _searchController.text = query;
                setState(() => _showAutocomplete = false);
                _focusNode.unfocus();
                context.read<SearchBloc>().add(SearchSubmitted(query));
              },
            );
          }

          // Search history
          if (state is SearchHistoryLoaded) {
            return _SearchHistory(
              history: state.history,
              onQueryTap: (query) {
                _searchController.text = query;
                _focusNode.unfocus();
                context.read<SearchBloc>().add(SearchSubmitted(query));
              },
              onRemove: (query) =>
                  context.read<SearchBloc>().add(RemoveFromHistory(query)),
              onClear: () =>
                  context.read<SearchBloc>().add(ClearSearchHistory()),
            );
          }

          // Loading
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Results
          if (state is SearchLoaded) {
            return _SearchResults(
              query: state.query,
              products: state.products,
              hasFilters: state.hasFilters,
            );
          }

          // Error
          if (state is SearchError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<SearchBloc>().add(SearchSubmitted(state.query)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showFiltersSheet(BuildContext context, SearchLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FiltersSheet(
        currentColorFilter: state.colorFilter,
        currentMinPrice: state.minPrice,
        currentMaxPrice: state.maxPrice,
        onApply: (color, minPrice, maxPrice) {
          context.read<SearchBloc>().add(ApplyFilters(
                colorFilter: color,
                minPrice: minPrice,
                maxPrice: maxPrice,
              ));
        },
        onClear: () {
          context.read<SearchBloc>().add(ClearFilters());
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Search Bar Widget
// ═══════════════════════════════════════════════════════════════════

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search products...',
        border: InputBorder.none,
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: colors.textSecondary),
                onPressed: onClear,
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Autocomplete Overlay
// ═══════════════════════════════════════════════════════════════════

class _AutocompleteOverlay extends StatelessWidget {
  final List<String> history;
  final String query;
  final ValueChanged<String> onSelect;

  const _AutocompleteOverlay({
    required this.history,
    required this.query,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    // Filter history by query
    final matches = history
        .where((h) => h.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    if (matches.isEmpty) return const SizedBox.shrink();

    return Container(
      color: colors.surface,
      child: ListView.separated(
        padding: spacing.pagePadding(context),
        itemCount: matches.length,
        separatorBuilder: (_, __) => Divider(color: colors.border, height: 1),
        itemBuilder: (context, index) {
          final suggestion = matches[index];
          return ListTile(
            leading: Icon(Icons.history, color: colors.textSecondary, size: 20),
            title: _HighlightedText(text: suggestion, query: query),
            onTap: () => onSelect(suggestion),
          );
        },
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text);
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: colors.textPrimary, fontSize: 14),
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Search History Widget
// ═══════════════════════════════════════════════════════════════════

class _SearchHistory extends StatelessWidget {
  final List<String> history;
  final ValueChanged<String> onQueryTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  const _SearchHistory({
    required this.history,
    required this.onQueryTap,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: colors.textSecondary),
            SizedBox(height: spacing.md),
            Text(
              'No search history',
              style: TextStyle(color: colors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: spacing.pagePadding(context).copyWith(
                top: spacing.md,
                bottom: spacing.sm,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: onClear,
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: spacing.pagePadding(context),
            itemCount: history.length,
            separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
            itemBuilder: (context, index) {
              final query = history[index];
              return _HistoryItem(
                query: query,
                onTap: () => onQueryTap(query),
                onRemove: () => onRemove(query),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _HistoryItem({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.history, color: colors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: colors.textSecondary),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Search Results Widget
// ═══════════════════════════════════════════════════════════════════

class _SearchResults extends StatelessWidget {
  final String query;
  final List products;
  final bool hasFilters;

  const _SearchResults({
    required this.query,
    required this.products,
    required this.hasFilters,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: colors.textSecondary),
            SizedBox(height: spacing.md),
            Text(
              'No results found for "$query"',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs),
            Text(
              hasFilters
                  ? 'Try adjusting your filters'
                  : 'Try a different search term',
              style: TextStyle(color: colors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: spacing.pagePadding(context).copyWith(
                top: spacing.md,
                bottom: spacing.sm,
              ),
          child: Text(
            '${products.length} ${products.length == 1 ? 'result' : 'results'} for "$query"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: spacing.pagePadding(context),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductGridItem(product: products[index], onTap: () {  }, onFavoriteToggle: () {  },);
            },
          ),
        ),
      ],
    );
  }
}

// Continued in next file...





class _FiltersSheet extends StatefulWidget {
  final String? currentColorFilter;
  final double? currentMinPrice;
  final double? currentMaxPrice;
  final Function(String?, double?, double?) onApply;
  final VoidCallback onClear;

  const _FiltersSheet({
    this.currentColorFilter,
    this.currentMinPrice,
    this.currentMaxPrice,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _selectedColor;
  late double? _minPrice;
  late double? _maxPrice;

  final List<String> _colors = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Black',
    'White',
    'Pink',
    'Purple',
    'Orange',
    'Brown',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColorFilter;
    _minPrice = widget.currentMinPrice;
    _maxPrice = widget.currentMaxPrice;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: spacing.pagePadding(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedColor = null;
                        _minPrice = null;
                        _maxPrice = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),

            Divider(color: colors.border),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: spacing.pagePadding(context),
                children: [
                  // Color Filter
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: spacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return FilterChip(
                        label: Text(color),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedColor = selected ? color : null;
                          });
                        },
                        selectedColor: colors.primary.withOpacity(0.2),
                        checkmarkColor: colors.primary,
                      );
                    }).toList(),
                  ),

                  SizedBox(height: spacing.lg),

                  // Price Range
                  Text(
                    'Price Range',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Min Price',
                            prefixText: '\$ ',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: _minPrice?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            _minPrice = double.tryParse(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'to',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Max Price',
                            prefixText: '\$ ',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: _maxPrice?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            _maxPrice = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.xxl),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: spacing.pagePadding(context).copyWith(
                    top: spacing.md,
                    bottom: spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        widget.onClear();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        widget.onApply(_selectedColor, _minPrice, _maxPrice);
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Error View
// ═══════════════════════════════════════════════════════════════════

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: spacing.pagePadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.error),
            SizedBox(height: spacing.md),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: spacing.xs),
            Text(
              message,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
