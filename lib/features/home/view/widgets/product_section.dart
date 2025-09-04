import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/features/home/model/category_model.dart';
import 'package:grocery_app/features/home/view/widgets/product_item.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class CategoryProductSection extends StatelessWidget {
  const CategoryProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        final categories = viewModel.categories;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final category = categories[index];
            final products = viewModel.getCategoryProducts(category.id);
            final isLoading = viewModel.categoryLoading(category.id);
            final hasMore = viewModel.categoryHasMore(category.id);

            return _buildCategorySection(
              context,
              category,
              products,
              isLoading,
              hasMore,
              viewModel,
            );
          }, childCount: categories.length),
        );
      },
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    CategoryModel category,
    List<ProductModel> products,
    bool isLoading,
    bool hasMore,
    HomeViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    "${products.length} items",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => GoRouter.of(
                  context,
                ).push(AppRouteName.categoryDetails, extra: category),
                child: Text(
                  "See All",
                  style: AppStyles.textMedium15.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 280,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!isLoading &&
                  hasMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                viewModel.fetchNextPageForCategory(category.id, loadMore: true);
              }
              return false;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  final product = products[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ProductItem(product: product),
                  );
                } else {
                  return const LoadingGridItem();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingGridItem extends StatefulWidget {
  const LoadingGridItem({super.key});

  @override
  State<LoadingGridItem> createState() => _LoadingGridItemState();
}

class _LoadingGridItemState extends State<LoadingGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
