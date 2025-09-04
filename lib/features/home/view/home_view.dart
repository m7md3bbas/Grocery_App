import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/features/cart/view/cart_view.dart';
import 'package:grocery_app/features/favorite/view/favorite_view.dart';
import 'package:grocery_app/features/home/view/home_view_body.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:grocery_app/features/profile/view/profile_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (page) => viewModel.setCurrentPage(page: page),
            children: [
              const HomeViewBody(),
              const FavoriteView(),
              const CartView(),
              const ProfileView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.currentPage,
            onTap: (index) {
              _pageController.jumpToPage(index);
              viewModel.setCurrentPage(page: index);
            },
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.house),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.heart),
                label: "Favorite",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bagShopping),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
