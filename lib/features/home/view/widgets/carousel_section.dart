import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CarouselSection extends StatelessWidget {
  CarouselSection({super.key});
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) => Stack(
        children: [
          CarouselSlider(
            items: viewModel.carosualImages
                .map(
                  (e) => CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    imageUrl: e,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 3.5,
              initialPage: 0,
              animateToClosest: true,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              autoPlay: true,
              onPageChanged: (index, reason) =>
                  viewModel.setCurrentIndex(index: index),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),

          Positioned.fill(child: Container(color: Colors.black45)),
          Positioned(
            left: 40,
            bottom: 60,
            child: Text(
              "20% off on your \n First Purchase",
              style: AppStyles.textBold20.copyWith(color: AppColors.primary),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: Row(
              spacing: 5,
              children: List.generate(
                viewModel.carosualImages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == viewModel.currentIndex
                        ? AppColors.primary
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
