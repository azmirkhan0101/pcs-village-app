import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/post.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final ScrollController scrollController = ScrollController();
  PaginationHelper postsHelper = PaginationHelper<Post>();

  @override
  void onInit() {
    if (postsHelper.items.isEmpty) {
      getPosts();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent * 0.9) {
        getPosts(refresh: false);
      }
    });
    super.onInit();
  }

  //GET POSTS
  Future<void> getPosts({bool refresh = true}) async {
    await postsHelper.fetch(
      isRefresh: refresh,
      apiCall: (page) => apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getAllPosts(page: page),
      ),
      fromJson: (json) => Post.fromJson(json),
      listExtractor: (data) => data['data'] as List<dynamic>?,
    );
  }
}
