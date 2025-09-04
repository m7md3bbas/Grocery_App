import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/features/auth/view/widget/custom_card_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome",
            style: AppStyles.textBold25.copyWith(fontStyle: FontStyle.italic),
          ),
          Text(
            "Please sign in to continue using our service",
            style: AppStyles.textMedium12,
          ),
          const SizedBox(height: 20),

          CustomCardAuth(
            onTap: () async {
              final result = await context
                  .read<AuthViewModel>()
                  .loginWithGoogle();
              if (result) {
                GoRouter.of(context).push(AppRouteName.home);
              }
            },
            iconColor: AppColors.primary,
            title: "Continue with Google",
            icon: FontAwesomeIcons.google,
            color: AppColors.background,
          ),
          CustomCardAuth(
            iconColor: AppColors.background,
            onTap: () => GoRouter.of(context).push(AppRouteName.signUp),
            title: "Create an account",
            icon: FontAwesomeIcons.user,
            color: AppColors.primary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account ?", style: AppStyles.textMedium15),
              TextButton(
                onPressed: () => GoRouter.of(context).push(AppRouteName.signIn),
                child: Text(
                  "Sign In",
                  style: AppStyles.textMedium15.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
