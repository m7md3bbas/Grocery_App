import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Favorite"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: () async => viewModel.getFavorite(
            userId: locator<AuthViewModel>().getCurrentUser()!.id,
          ),
          child: Builder(
            builder: (context) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.error.isNotEmpty) {
                return Center(
                  child: Text(
                    "Error: ${viewModel.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (viewModel.favoriteList.isEmpty) {
                return const Center(child: Text("No favorites yet "));
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: viewModel.favoriteList.length,
                itemBuilder: (context, index) {
                  final favorite = viewModel.favoriteList
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  final product = favorite[index].product;

                  return GestureDetector(
                    onTap: () => GoRouter.of(
                      context,
                    ).push(AppRouteName.productDetails, extra: product),
                    child: _buildFavoriteItem(
                      product: product,
                      onRemove: () async {
                        await viewModel
                            .removeFromFavorite(
                              favoriteId: favorite[index].id,
                              userId: locator<AuthViewModel>()
                                  .getCurrentUser()!
                                  .id,
                            )
                            .then(
                              (_) => ShowToast.showInfo(
                                "${product.title} removed from favorite",
                              ),
                            );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem({
    required ProductModel product,
    required VoidCallback onRemove,
  }) {
    return Dismissible(
      key: ValueKey(product.id),
      onDismissed: (direction) => onRemove(),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: product.image ?? "",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorWidget: (ctx, url, error) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        ),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product.description ?? "",
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
