import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/widgets/dismisskeyboard.dart';
import 'package:grocery_app/core/widgets/textformfield/custom_textformfield.dart';
import 'package:grocery_app/features/home/view/widgets/product_item.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:grocery_app/features/search/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, value, child) => KeyboardDismissOnTap(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                title: CustomTextFormField(
                  onChanged: (query) {
                    context.read<SearchViewModel>().searchProduct(query: query);
                  },

                  hintText: "Search",
                  backGorundColor: AppColors.backgroundGrey,
                  suffixIcon: Icon(Icons.tune),
                  textInputType: TextInputType.text,
                  controller: searchController,
                ),
                pinned: true,
                floating: true,
              ),
            ],
            body: value.searchProducts.isEmpty
                ? Center(child: Text("No products found"))
                : CustomScrollView(
                    slivers: [
                      NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            if (notification.metrics.pixels ==
                                notification.metrics.maxScrollExtent) {
                              context.read<SearchViewModel>().checkLoadMore(
                                query: searchController.text,
                              );
                            }
                          }
                          return false;
                        },
                        child: SliverList.builder(
                          itemCount:
                              value.searchProducts.length +
                              (value.isLoading ? 1 : 0),
                          itemBuilder: (context, index) =>
                              index < value.searchProducts.length
                              ? ProductItem(
                                  product: value.searchProducts[index],
                                )
                              : LoadingGridItem(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
