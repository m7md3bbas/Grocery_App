import 'package:flutter/material.dart';
import 'package:grocery_app/features/home/model/category_model.dart';
import 'package:grocery_app/features/home/view/widgets/product_item.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final CategoryModel category;
  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: Text(category.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            final products = homeViewModel.getCategoryProducts(category.id);
            final isLoading = homeViewModel.categoryLoading(category.id);
            final hasMore = homeViewModel.categoryHasMore(category.id);

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    !isLoading &&
                    hasMore &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 50) {
                  homeViewModel.fetchNextPageForCategory(
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
                itemCount: products.length + (isLoading ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    return ProductItem(product: product);
                  } else {
                    return const LoadingGridItem();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
