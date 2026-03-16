import 'package:cached_network_image/cached_network_image.dart';
import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:echoemaar_commerce/features/home/presentation/widgets/theme_background.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/category.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/categories/category_bloc.dart';
import 'package:echoemaar_commerce/injection_container.dart' as di;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Assuming your Category model is imported here
// import 'models/category.dart'; 
// Assuming your existing CategoryCard widget is imported here
// import 'widgets/category_card.dart'; 

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // 1. State variables for data fetching (Replace with your BLoC/Provider state)
  bool _isLoading = false;
  
  // Mock data tailored for sanitary ware & luxury portal testing
  final List<Category> _categories = const [
    Category(id: 1, name: 'أطقم حمامات', imageUrl: 'assets/images/bathroom_sets.jpg'),
    Category(id: 2, name: 'خلاطات مياه', imageUrl: 'assets/images/mixers.jpg'),
    Category(id: 3, name: 'بانيوهات وجاكوزي', imageUrl: 'assets/images/bathtubs.jpg'),
    Category(id: 4, name: 'مغاسل فاخرة', imageUrl: 'assets/images/sinks.jpg'),
    Category(id: 5, name: 'إكسسوارات', imageUrl: 'assets/images/accessories.jpg'),
    Category(id: 6, name: 'سيراميك وبورسلان', imageUrl: 'assets/images/tiles.jpg'),
  ];

  // 2. Refresh handler
  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Access your dynamic theme colors and text styles
    final colors = context.colors; 
    final textStyles = context.textTheme;

    
    
    return BlocProvider(
      create: (_) => di.sl<CategoryBloc>()..add(LoadCategorisEvent()),
      child:  _CategoriesView(context),
    );
    
  
  
  }

  Widget _CategoriesView(BuildContext context){
final colors = context.colors; 
    final textStyles = context.textTheme;
   return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'التصنيفات', // Categories
          style: textStyles.headlineLarge!.copyWith(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        // Optional: Add a search icon action
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colors.textPrimary),
            onPressed: () {
              // Navigate to search
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryStateLoading) {
              return const _LoadingView();
            }

            if (state is CategoryStateError) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<CategoryBloc>().add(LoadCategorisEvent()),
              );
            }

                      if (state is CategoryStateLoaded) {
            return RefreshIndicator(
              color: colors.primary,
              backgroundColor: colors.surface,
              onRefresh: _handleRefresh,
              child: _buildBody(context ,state),
            );


            }

             return const SizedBox.shrink();
          }
        ),
      ),
    );
  
  }

  Widget _buildBody(BuildContext context , CategoryState state) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.primary),
      );
    }

    if ((state as CategoryStateLoaded).categories.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تصنيفات حالياً', // No categories currently
          style: context.textTheme.bodyLarge,
        ),
      );
    }

    return GridView.builder(
      // Padding around the entire grid
      padding: const EdgeInsets.all(16.0),
      // Physics ensures the grid is always scrollable, even if items don't fill the screen 
      // (required for RefreshIndicator to work properly)
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // Max width of a single card
        childAspectRatio: 0.85,  // Height vs Width ratio (adjust based on your CategoryCard shape)
        crossAxisSpacing: 16,    // Horizontal space between cards
        mainAxisSpacing: 16,     // Vertical space between cards
      ),
      itemCount: (state).categories.length,
      itemBuilder: (context, index) {
        final category = (state).categories[index];
        
        // --- INJECT YOUR EXISTING CATEGORY CARD HERE ---
        // Replace this Placeholder with your actual widget:
        // return CategoryCard(category: category);
        
        return _PlaceholderCategoryCard(category: category); 
      },
    );
  }
}





class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}



class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: spacing.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
                const _Shimmer(width: 120, height: 28),
                spacing.verticalSM,
                const _Shimmer(width: 200, height: 16),
                spacing.verticalLG,

                // Search bar shimmer
                const _Shimmer(width: double.infinity, height: 48),
                spacing.verticalLG,

                // Category chips shimmer
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      5,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: spacing.sm),
                        child: const _Shimmer(width: 100, height: 80),
                      ),
                    ),
                  ),
                ),
                spacing.verticalXL,

                // Product grid shimmer
                ...List.generate(3, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Shimmer(width: 150, height: 24),
                      spacing.verticalMD,
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: spacing.sm),
                          itemBuilder: (_, __) =>
                              const _Shimmer(width: 160, height: 220),
                        ),
                      ),
                      spacing.verticalXL,
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




class _Shimmer extends StatelessWidget {
  final double width;
  final double height;

  const _Shimmer({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Error View
// ═══════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════

/// A temporary visual placeholder until you drop in your actual CategoryCard
class _PlaceholderCategoryCard extends StatelessWidget {
  final Category category;

  const _PlaceholderCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return ThemeBackground(
      child: Container(
        decoration: BoxDecoration(
          // color: colors.surface,
                          // color: colors.primary,
      
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Expanded(
              child: CachedNetworkImage(imageUrl:
              
              category.imageUrl??'', 
              // height: 50, width: 50,
              fit: BoxFit.cover,
      
              errorWidget: (context, url, error) {
                return Center(child: Icon(Icons.category,size: 35, color: colors.primary,),);
              },
              ),
      
            ),
            const SizedBox(height: 12),
            Text(
                category.name,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600 , color: Colors.white),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}