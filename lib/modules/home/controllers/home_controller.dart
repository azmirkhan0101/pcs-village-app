import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/post.dart';

class HomeController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController postScrollController = ScrollController();
  final postsHelper = PaginationHelper<Post>();

  @override
  void onInit() {

    initPostsHelper();

    if (postsHelper.items.isEmpty) {
      getPosts();
    }
    super.onInit();
  }

  void initPostsHelper(){
    postsHelper.init(
        endPoint: (page) => ApiEndpoints.getAllPosts(page: page),
        fromJson: (json) => Post.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: postScrollController
    );
  }

  //GET POSTS
  Future<void> getPosts() async {
    await postsHelper.fetch(isRefresh: true);
  }
}
