import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/core/widgets/dismisskeyboard.dart';
import 'package:grocery_app/core/widgets/textformfield/custom_textformfield.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/home/view/widgets/caregory_section.dart';
import 'package:grocery_app/features/home/view/widgets/carousel_section.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:provider/provider.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Consumer<CartViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          body: RefreshIndicator(
            color: Colors.green,
            onRefresh: () async {},
            child: SafeArea(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    actionsPadding: const EdgeInsets.all(0),
                    title: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        ontap: () =>
                            GoRouter.of(context).push(AppRouteName.search),
                        readOnly: true,
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),

                    pinned: true,
                    floating: true,
                    backgroundColor: Colors.white,
                  ),
                ],
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: CarouselSection()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Text(
                            "Categories",
                            style: AppStyles.textBold20,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: CaregorySection()),

                    CategoryProductSection(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: viewModel.cartItems.isNotEmpty
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.cartItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final item = viewModel.cartItems[index];
                            return Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Expanded(
                                    child: Image.asset(
                                      "assets/images/home/aocado-2 1.png",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: -3,
                                  child: GestureDetector(
                                    onTap: () {
                                      viewModel.removeLocal(item.id);
                                      viewModel.removeFromCart(
                                        item.userId,
                                        item.id,
                                        item.productId,
                                      );
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).push(AppRouteName.cart);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "View your bag",
                              style: AppStyles.textBold15.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
