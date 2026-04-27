import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/blast_post/blast_post_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/app_colors.dart';

class BlastPostController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController postScrollController = ScrollController();
  final TextEditingController websiteUrlController = TextEditingController();
  final blastPostsHelper = PaginationHelper<BlastPostModel>();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isPostUploading = false.obs;

  @override
  void onInit() {

    initBlastPostsHelper();

    getMyBlastPosts();
    super.onInit();
  }

void initBlastPostsHelper(){
  blastPostsHelper.init(
        endPoint: (page) => ApiEndpoints.getMyBlastPosts(page: page),
        fromJson: (json) => BlastPostModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: postScrollController,
    showMessageOnError: true
    );
}
  //GET MY BLAST POSTS
Future<void> getMyBlastPosts() async{
    await blastPostsHelper.fetch(isRefresh: true, shouldPrint: true);
}

void removeBannerImage(){
    selectedImage.value = null;
}

Future<void> createBlastPost() async{

    if( isPostUploading.value ){
      return;
    }

    if( selectedImage.value == null ){
      showSnackBar(title: "Attention", message: "Please select an image", backgroundColor: AppColors.warningYellow);
      return;
    }

    isPostUploading.value = true;

    Map<String, String> payLoad = {
      "url" : websiteUrlController.text.trim()
    };

    ApiResponse response = await apiService.multipartRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: ApiEndpoints.createBlastPost,
      fields: payLoad,
      image: selectedImage.value,
      imageKey: "banner"
  );
    isPostUploading.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      getMyBlastPosts();
      Get.back();
    }else{
      showApiSnackBar(
          statusCode: response.statusCode, data: response.data
      );
    }
}

//DELETE
  Future<void> deleteBlastPost({required String id}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: ApiEndpoints.deleteBlastPost(id: id),
      shouldPrint: true
    );

    if( response.statusCode == 200 || response.statusCode == 201 ){
      getMyBlastPosts();
    }else{
      showApiSnackBar(
          statusCode: response.statusCode, data: response.data
      );
    }
  }

  //OPEN website LINK IN BROWSER
  Future<void> openLinkInBrowser({required String websiteLink}) async {
    final Uri? url = Uri.tryParse(websiteLink);

    if (url == null || !url.hasScheme) {
      showSnackBar(title: "Cannot open", message: "Invalid URL format", backgroundColor: AppColors.errorRed);
      return;
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        showSnackBar(title: "Failed", message: "No application found to handle this link.", backgroundColor: AppColors.errorRed);
      }
    } catch (e) {
      showSnackBar(title: "Cannot open link", message: "Error launching URL", backgroundColor: AppColors.errorRed);
    }
  }

// Image Picker Logic
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      selectedImage.value = file;
    }
  }

@override
  void onClose() {

    postScrollController.dispose();
    websiteUrlController.dispose();

    super.onClose();
  }

}