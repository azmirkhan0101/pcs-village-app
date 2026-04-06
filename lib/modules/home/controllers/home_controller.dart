import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/post.dart';

class HomeController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  RxList<Post> posts = <Post>[].obs;
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool hasMorePosts = true;
  RxBool isPostsLoading = false.obs;
  RxBool isPostsMoreLoading = false.obs;

  @override
  void onInit() {

    if( posts.isEmpty ){
      getPosts();
    }

    scrollController.addListener((){
      if( scrollController.position.pixels == scrollController.position.maxScrollExtent * 0.9 ){
        getPosts(refresh: false);
      }
    });
    super.onInit();
  }

  //GET POSTS
Future<void> getPosts({bool refresh = true}) async{
    if( refresh ){
      currentPage = 1;
      hasMorePosts = true;
      isPostsLoading.value = true;
    }else{
      if( isPostsMoreLoading.value == true || hasMorePosts == false ){
        return;
      }
      isPostsMoreLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getAllPosts(page: currentPage)
    );

    if( response.statusCode == 200 ){
      final fetchedPosts = response.data['data'] as List<dynamic>?;
      if( fetchedPosts is List && fetchedPosts.isNotEmpty ){
        if( refresh ){
          posts.assignAll(fetchedPosts.map((e){
            return Post.fromJson(e);
          }).toList());
        }else{
          posts.addAll(fetchedPosts.map((e){
            return Post.fromJson(e);
          }).toList());
        }
        if( fetchedPosts.length < 10 ){
          hasMorePosts = false;
        }else{
          currentPage++;
        }
      }
    }
}
}



