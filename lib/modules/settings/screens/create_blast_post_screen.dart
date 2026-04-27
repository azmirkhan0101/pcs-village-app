import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/modules/post/controllers/create_post_controller.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/modules/settings/controllers/blast_post_controller.dart';

class CreateBlastPostScreen extends StatelessWidget {
  CreateBlastPostScreen({super.key});

  final BlastPostController controller = Get.find<BlastPostController>();
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
          'Create Blast Post',
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
                label: "Publish",
                fontSize: 14,
                textColor: Colors.white,
                backgroundColor: const Color(0xFF8E9AAF),
                onPressed: (){
                  controller.createBlastPost();
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
              controller: controller.websiteUrlController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Website url",
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
              if (controller.selectedImage.value == null) return const SizedBox.shrink();

              return SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(controller.selectedImage.value!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Cross Icon to remove image
                    Positioned(
                      top: 5,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => controller.removeBannerImage(),
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
                )
              );
            }),
            const SizedBox(height: 15,),
            // Add Photos Button
            CustomButton(
                label: "Add banner image",
              textColor: AppColors.primaryColor,
              prefixIcon: Icons.image,
              prefixIconColor: AppColors.primaryColor,
              borderWidth: 0,
              borderColor: Colors.transparent,
              backgroundColor: const Color(0xFFF5F5F2),
              onPressed: (){
                  controller.pickImage();
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
                    'Rules:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D4369),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGuidelineItem('No explicit language'),
                  //_buildGuidelineItem('No '),
                  _buildGuidelineItem('No spamming'),
                  _buildGuidelineItem("No harmful material"),
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