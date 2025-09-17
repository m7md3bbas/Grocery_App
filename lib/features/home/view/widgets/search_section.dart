import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/route_name.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/widgets/textformfield/custom_textformfield.dart';

class SearchSection extends StatelessWidget {
  SearchSection({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.backgroundGrey,
      ),
      child: CustomTextFormField(
        ontap: () => context.goNamed(AppRouteName.search),
        textInputType: TextInputType.text,
        backGorundColor: AppColors.backgroundGrey,
        borderColor: AppColors.backgroundGrey,
        suffixIcon: Icon(Icons.tune),
        controller: controller,
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
