import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CaregorySection extends StatelessWidget {
  const CaregorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = viewModel.categories[index];
              final color = (int.parse(category.color));
              return GestureDetector(
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push(AppRouteName.categoryDetails, extra: category);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(color),
                        radius: 50,
                        child: SvgPicture.network(
                          category.image!,
                          height: 50,
                          width: 40,
                        ),
                      ),
                      Text(category.title, style: AppStyles.textBold15),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
