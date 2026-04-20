import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/post/post.dart';
import 'package:pcs_village/modules/groups/controllers/groups_details_controller.dart';
import 'package:pcs_village/modules/home/controllers/home_controller.dart';

class EditPostController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  RxBool isPostUpdating = false.obs;

  RxList<String> existingImages = <String>[].obs;
  RxList<File> selectedImages = <File>[].obs;

  final TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late Post post;
  //GROUP POST OR COMMUNITY POST
  late bool isGroup;

  HomeController? homeController;
  GroupsDetailsController? groupsDetailsController;

  @override
  void onInit() {

    isGroup = Get.arguments['isGroup'] as bool? ?? false;
    post = Get.arguments['post'] as Post;
    contentController.text = post.content;
    existingImages.addAll(post.attachments);

    if( isGroup ){
      groupsDetailsController = Get.find<GroupsDetailsController>();
    }else{
      homeController = Get.find<HomeController>();
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

  //DELETE NETWORK IMAGE
  Future<void> deleteNetworkImage({required String imageUrl, required int attachmentIndex}) async{

    Map<String, String> payLoad = {
      "url": imageUrl
    };
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: isGroup
            ? ApiEndpoints.deleteGroupPostImage(postId: post.id)
            : ApiEndpoints.deleteCommunityPostImage(postId: post.id),
      body: payLoad
    );

    if( response.statusCode == 200 ){
      existingImages.removeAt(attachmentIndex);
      post.attachments.removeAt(attachmentIndex);
      if( isGroup ){
        groupsDetailsController?.postsHelper.items.refresh();
      }else{
        homeController?.displayPosts.refresh();
      }
    }else{
      showSnackBar(title: "Error", message: response.data?['message'] ?? "Something went wrong", backgroundColor: AppColors.warningYellow);
    }
  }

  // Remove local selected image
  void removeLocalImage(int index) {
    selectedImages.removeAt(index);
  }

  //UPDATE POST
  Future<void> updatePost({bool refresh = true}) async {

    if (isPostUpdating.value) {
      return;
    }

    isPostUpdating.value = true;

    Map<String, String> payLoad = {
      "content" : contentController.text.trim()
    };

    ApiResponse response = await apiService.multipartRequest(
      method: "PATCH",
      isAuthRequired: true,
      endPoint: isGroup ? ApiEndpoints.updateGroupPost(postId: post.id) : ApiEndpoints.updateCommunityPost(postId: post.id),
        fields: payLoad,
      images: selectedImages.value,
      imageKey: "attachments"
    );

    isPostUpdating.value = false;

    if (response.statusCode == 200) {
      if( isGroup ){
        groupsDetailsController?.getPosts();
        //groupsDetailsController?.getPostById(postId: post.id);
      }else{
        homeController?.getPosts();
        //homeController?.getPostById(postId: post.id);
      }
      Get.back();
      //showSnackBar(title: "Uploaded", message: "Your post has been uploaded successfully!", backgroundColor: AppColors.greenPrimary);
    }else{
      showApiSnackBar(
          statusCode: response.statusCode,
        data: response.data
      );
    }
  }
}
