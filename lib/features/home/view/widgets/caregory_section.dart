import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/route_name.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
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
                  context.pushNamed(
                    AppRouteName.categoryDetails,
                    extra: category,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(color),
                        radius: 50,
                        child: SvgPicture.network(
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                          placeholderBuilder: (context) =>
                              CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
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
