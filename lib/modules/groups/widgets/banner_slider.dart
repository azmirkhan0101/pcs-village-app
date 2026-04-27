import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/data/models/blast_post/blast_post_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_colors.dart';

class BannerSlider extends StatelessWidget {

  final List<BlastPostModel> bannerModels;
  final Function(String adUrl) onTap;

  BannerSlider({
    super.key,
    required this.bannerModels,
    required this.onTap
  });

  final CarouselSliderController _sliderController = CarouselSliderController();

  var currentIndex = 0.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        CarouselSlider(
          carouselController: _sliderController,
          options: CarouselOptions(
            height: 150.h,
            aspectRatio: 9/16,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              updateIndex(index); // Update GetX state
            },
          ),
          items: bannerModels.map((post) {
            return GestureDetector(
              onTap: (){
                onTap(post.url);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: AppColors.greenPrimary.withValues(alpha: 0.6),
                  child: CachedNetworkImage(
                    imageUrl: post.banner,
                    fit: BoxFit.cover,
                    placeholder: (context, url){
                      return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child:  Container(color: Colors.white)
                      );
                    },
                    width: double.infinity,
                    errorWidget: (context, url, error) => Icon(
                      Icons.image,
                      size: 70.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        //Obx only wraps the part that needs to change
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerModels.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _sliderController.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentIndex.value == entry.key ? 25.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: currentIndex.value == entry.key
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}
