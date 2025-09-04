import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/features/home/model/category_model.dart';
import 'package:grocery_app/features/home/view/widgets/product_item.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final category = GoRouterState.of(context).extra as CategoryModel;
    final products = context.watch<HomeViewModel>().getCategoryProducts(
      category.id,
    );
    final isLoading = context.watch<HomeViewModel>().categoryLoading(
      category.id,
    );
    final hasMore = context.watch<HomeViewModel>().categoryHasMore(category.id);
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: Text(category.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!isLoading &&
                hasMore &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50) {
              context.read<HomeViewModel>().fetchNextPageForCategory(
                loadMore: true,
                category.id,
              );
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            scrollDirection: Axis.vertical,
            itemCount: products.length + (isLoading ? 2 : 0),
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
    );
  }
}
