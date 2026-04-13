import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';

class CreatePostController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();

  RxBool isPostUploading = false.obs;

  RxList<File> selectedImages = <File>[].obs;

  final TextEditingController contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  //GROUP POST OR COMMUNITY POST
  late bool isGroup;
  late String groupId;

  @override
  void onInit() {

    isGroup = Get.arguments['isGroup'] as bool? ?? false;

    if( isGroup ){
      groupId = Get.arguments['groupId'] as String;
    }

    super.onInit();
  }

  // Pick multiple images from gallery
  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((image) => File(image.path)).toList());
    }
  }

  // Remove a specific image
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  //GET POSTS
  Future<void> createPost({bool refresh = true}) async {

    if (isPostUploading.value) {
      return;
    }

    isPostUploading.value = true;

    Map<String, String> payLoad = {
      "content" : contentController.text.trim(),
      if( isGroup ) "group" : groupId
    };

    ApiResponse response = await apiService.multipartRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: isGroup ? ApiEndpoints.createGroupPost : ApiEndpoints.createPost,
        fields: payLoad,
      images: selectedImages.value,
      imageKey: "attachments"
    );

    isPostUploading.value = false;

    if (response.statusCode == 201) {
      showSnackBar(title: "Uploaded", message: "Your post has been uploaded successfully!", backgroundColor: AppColors.greenPrimary);
    }else{
      showSnackBar(title: "Error", message: response.data?['message'] ?? "Something went wrong", backgroundColor: AppColors.warningYellow);
    }
  }
}
