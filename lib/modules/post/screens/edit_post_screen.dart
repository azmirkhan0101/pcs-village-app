// ... existing imports ...

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/edit_post_controller.dart';

class EditPostScreen extends StatelessWidget {
  EditPostScreen({super.key});

  final EditPostController controller = Get.find<EditPostController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          'Edit Post',
          style: TextStyle(
            color: Color(0xFF2D4369),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() {
              return CustomButton(
                buttonRadius: 100,
                label: "Update",
                textColor: Colors.white,
                backgroundColor: const Color(0xFF8E9AAF),
                borderColor: Colors.transparent,
                borderWidth: 0,
                onPressed: (){
                  if (formKey.currentState!.validate()) {
                    controller.updatePost();
                  }
                },
                isLoading: controller.isPostUpdating.value,
              );
            }),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section (Kept as is)
              _buildUserHeader(),
              const SizedBox(height: 20),

              // Text Input Field
              CustomTextField(
                hintText: "Edit your post...",
                controller: controller.contentController,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                maxLines: 10,
                borderColor: Colors.grey.shade200,
                borderRadius: 15,
                validator: (value) {
                  if (value == null || controller.contentController.text.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: "Edit your post...",
              //     hintStyle:
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(15),
              //       borderSide: BorderSide(color: ),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter some text';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 16),

              // Unified Image List
              Obx(() {
                // Combine lengths: network images first, then local files
                int networkCount = controller.existingImages.length;
                int fileCount = controller.selectedImages.length;
                int totalCount = networkCount + fileCount;

                if (totalCount == 0) return const SizedBox.shrink();

                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: totalCount,
                    itemBuilder: (context, index) {
                      // Logic to determine if we show a Network image or File image
                      if (index < networkCount) {
                        // 1. Pre-assigned Network Images
                        String imageUrl = controller.existingImages[index];
                        return _buildImageItem(
                          child: CachedImageWidget(imageUrl: imageUrl),
                          onRemove: () => controller.deleteNetworkImage(
                              imageUrl: imageUrl,
                              attachmentIndex: index
                          ),
                          isNetwork: true,
                        );
                      } else {
                        // 2. Newly selected File Images
                        int fileIndex = index - networkCount;
                        return _buildImageItem(
                          child: Image.file(
                            controller.selectedImages[fileIndex],
                            fit: BoxFit.cover,
                          ),
                          onRemove: () => controller.removeLocalImage(fileIndex),
                          isNetwork: false,
                        );
                      }
                    },
                  ),
                );
              }),

              const SizedBox(height: 15),

              // Add Photos Button
              CustomButton(
                label: AppStrings.addPhotos,
                textColor: AppColors.primaryColor,
                prefixIcon: Icons.image,
                prefixIconColor: AppColors.primaryColor,
                borderWidth: 0,
                borderColor: Colors.transparent,
                backgroundColor: const Color(0xFFF5F5F2),
                onPressed: () => controller.pickImages(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to keep the list items consistent
  Widget _buildImageItem({required Widget child, required VoidCallback onRemove, required bool isNetwork}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: child,
          ),
        ),
        Positioned(
          top: 5,
          right: 15,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
        if (isNetwork) // Subtle indicator that this is already saved
          const Positioned(
            bottom: 5,
            left: 5,
            child: Icon(Icons.cloud_done, size: 14, color: Colors.white70),
          ),
      ],
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 40, width: 40,
            color: Colors.grey.shade200,
            child: Obx(() => CachedImageWidget(
              imageUrl: profileController.profileModel.value?.profileImage ?? "",
              iconSize: 30,
            )),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              profileController.profileModel.value?.name ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D4369)),
            )),
            Obx(() => Text(
              profileController.profileModel.value?.currentStation?.name ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            )),
          ],
        ),
      ],
    );
  }
}