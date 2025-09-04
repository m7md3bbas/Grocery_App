import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/core/widgets/dismisskeyboard.dart';
import 'package:grocery_app/core/widgets/textformfield/custom_textformfield.dart';
import 'package:grocery_app/features/home/view/widgets/caregory_section.dart';
import 'package:grocery_app/features/home/view/widgets/carousel_section.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: () async {},
          child: SafeArea(
            child: NestedScrollView(
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
                  // SliverToBoxAdapter(
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: CustomTextFormField(
                  //       ontap: () =>
                  //           GoRouter.of(context).push(AppRouteName.search),
                  //       readOnly: true,
                  //       hintText: "Search",
                  //       prefixIcon: Icon(Icons.search),
                  //       backGorundColor: AppColors.backgroundGrey,
                  //     ),
                  //   ),
                  // ),
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
      ),
    );
  }
}
