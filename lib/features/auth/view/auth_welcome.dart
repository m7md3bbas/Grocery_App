import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/constants/images.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/features/auth/view/widget/welcome_section.dart';

class AuthWelcome extends StatelessWidget {
  const AuthWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            imageUrl: AppImages.auth,
            fit: BoxFit.cover,
          ),
          WelcomeSection(),
        ],
      ),
    );
  }
}
