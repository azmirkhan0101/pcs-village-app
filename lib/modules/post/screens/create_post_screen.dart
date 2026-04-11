import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/modules/post/controllers/create_post_controller.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final CreatePostController controller = Get.find<CreatePostController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Color(0xFF2D4369),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx((){
              return CustomButton(
                buttonRadius: 100,
                label: "Post",
                textColor: Colors.white,
                backgroundColor: const Color(0xFF8E9AAF),
                onPressed: (){
                  controller.createPost();
                },
                isLoading: controller.isPostUploading.value,
              );
            })
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey.shade200,
                    child: Obx((){
                      return CachedImageWidget(
                          imageUrl: profileController.profileModel.value?.profileImage ?? "",
                        iconSize: 30,
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx((){
                      return Text(
                        profileController.profileModel.value?.name ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D4369),
                        ),
                      );
                    }),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        Obx((){
                          return Text(
                            ' ${profileController.profileModel.value?.currentStation?.name ?? ""}',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Text Input Field
            TextField(
              controller: controller.contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "What's on your mind? Ask a question...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.selectedImages.isEmpty) return const SizedBox.shrink();

              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(controller.selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Cross Icon to remove image
                        Positioned(
                          top: 5,
                          right: 15,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 15,),
            // Add Photos Button
            CustomButton(
                label: AppStrings.addPhotos,
              textColor: AppColors.primaryColor,
              prefixIcon: Icons.image,
              prefixIconColor: AppColors.primaryColor,
              borderWidth: 0,
              borderColor: Colors.transparent,
              backgroundColor: const Color(0xFFF5F5F2),
              onPressed: (){
                  controller.pickImages();
              },
            ),
            const SizedBox(height: 15),

            // Community Guidelines Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F0E6), // Light beige background
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Community Guidelines',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D4369),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGuidelineItem('Be respectful and supportive'),
                  _buildGuidelineItem('No personal attacks or harassment'),
                  _buildGuidelineItem('Keep content family-friendly'),
                  _buildGuidelineItem("Protect OPSEC - don't share sensitive info"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for guidelines list
  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.grey, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF6C7A92), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}