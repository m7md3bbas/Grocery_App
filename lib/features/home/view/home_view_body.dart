import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/core/widgets/dismisskeyboard.dart';
import 'package:grocery_app/core/widgets/textformfield/custom_textformfield.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/home/view/widgets/caregory_section.dart';
import 'package:grocery_app/features/home/view/widgets/carousel_section.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
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
          bottomNavigationBar:
              context.watch<HomeViewModel>().isShowCart &&
                  viewModel.cartItems.isNotEmpty
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  height: 100,
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
                                  backgroundColor: Colors.grey[200],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/images/home/aocado-2 1.png",
                                      fit: BoxFit.cover,
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.push(AppRouteName.cart),
                        child: Icon(
                          FontAwesomeIcons.bagShopping,
                          size: 35,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),

                      GestureDetector(
                        onTap: () =>
                            context.read<HomeViewModel>().toggleShowCart(),
                        child: Icon(
                          FontAwesomeIcons.xmark,
                          color: AppColors.primary,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                )
              : null,

          floatingActionButton:
              context.watch<HomeViewModel>().isShowCart &&
                  viewModel.cartItems.isNotEmpty
              ? null
              : FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (viewModel.cartItems.isNotEmpty) {
                      context.read<HomeViewModel>().toggleShowCart();
                    } else {
                      ShowToast.showInfo(
                        "Cart is empty, please add some items",
                      );
                    }
                  },
                  child: Icon(
                    FontAwesomeIcons.bagShopping,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
