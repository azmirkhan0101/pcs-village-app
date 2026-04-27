import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/blast_post/blast_post_model.dart';
import '../../../data/models/post/post.dart';

class GroupsDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;
  late GroupModel groupModel;

  // POSTS
  final postsHelper = PaginationHelper<Post>();
  final ScrollController postScrollController = ScrollController();
  final RxBool isPostsLoaded = false.obs;

  // MEMBERS
  final membersHelper = PaginationHelper<MemberModel>();
  RxList<MemberModel> displayMembers = <MemberModel>[].obs;
  List<MemberModel> originalMembersBackup = <MemberModel>[];
  final ScrollController membersScrollController = ScrollController();
  final RxBool isMembersLoaded = false.obs;

  TextEditingController searchController = TextEditingController();

  final RxBool isJoined = false.obs;
  final RxBool isLeaving = false.obs;
  final RxBool isJoining = false.obs;

  final RxBool isLikeLoading = false.obs;

  Timer? _debounce;


  final bannerHelper = PaginationHelper<BlastPostModel>();

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    groupModel = Get.arguments as GroupModel;
    isJoined.value = groupModel.isAlreadyJoined;

    initBannerHelper();
    initPostsHelper();
    initMembersHelper(searchQuery: "");
    setupSearchListener();

    tabController.addListener( onTabChanged );

    getAllBanners();
    if ( isJoined.value && postsHelper.items.isEmpty ) {
      getPosts();
    }
  }

  void initBannerHelper(){
    bannerHelper.init(
        endPoint: (page) => ApiEndpoints.getAllBanners,
        fromJson: (json) => BlastPostModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
        //scrollController: postScrollController,
        //showMessageOnError: true
    );
  }

  Future<void> getAllBanners() async{
    await bannerHelper.fetch(isRefresh: true, shouldPrint: true);
  }

  void setupSearchListener() {
    searchController.addListener(() {
      _onSearchChanged(searchController.text.trim());
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        initMembersHelper(searchQuery: query);
        getMembers(isSearch: true);
      }else{
        initMembersHelper(searchQuery: "");
        displayMembers.assignAll(originalMembersBackup);
      }
    });
  }

  void initPostsHelper() {
    postsHelper.init(
        endPoint: (page) => ApiEndpoints.getGroupPosts( groupId: groupModel.id, page: page ),
        fromJson: (json) => Post.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: postScrollController
    );
  }

  void initMembersHelper({required String searchQuery}) {
    membersHelper.init(
        endPoint: (page) => ApiEndpoints.getGroupMembers(groupId: groupModel.id, page: page, searchQuery: searchQuery),
        fromJson: (json) => MemberModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: membersScrollController
    );
  }

  void onTabChanged() {
    if (!isJoined.value) return;
    if (tabController.indexIsChanging) return;

    if (tabController.index == 0) {
      currentTabIndex.value = 0;
      if (!isPostsLoaded.value) getPosts();
    } else {
      currentTabIndex.value = 1;
      if (!isMembersLoaded.value) getMembers();
    }
  }

  // ====== GET POSTS ======
  Future<void> getPosts() async {
    isPostsLoaded.value = false;
    await postsHelper.fetch(isRefresh: true);
    isPostsLoaded.value = true;
  }

  //==========GET POST BY ID - AFTER UPDATE========
  Future<void> getPostById({required String postId}) async{
    final post = postsHelper.items.firstWhereOrNull((p) => p.id == postId);
    if( post != null ){
      final ApiResponse response = await apiService.networkRequest(
          method: "GET",
          isAuthRequired: true,
          endPoint: ApiEndpoints.getGroupPostById(postId: postId)
      );
      //postsHelper.items.refresh();
    }
  }

  // ====== GET MEMBERS ======
  Future<void> getMembers({bool isSearch = false}) async {
    isMembersLoaded.value = false;
    await membersHelper.fetch(isRefresh: true, shouldPrint: true);
    displayMembers.assignAll(membersHelper.items);
    if( !isSearch ){
      originalMembersBackup.assignAll(membersHelper.items);
    }
    isMembersLoaded.value = true;
  }

  // ====== JOIN GROUP ======
  Future<void> joinGroup() async {
    if (isJoining.value) return;
    isJoining.value = true;

    final ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: true,
      endPoint: ApiEndpoints.joinGroup(groupId: groupModel.id),
    );

    isJoining.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      isJoined.value = true;
      getPosts();
    }
  }

  // ====== LEAVE GROUP ======
  Future<void> leaveGroup() async {
    if (isLeaving.value) return;
    isLeaving.value = true;

    final ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: true,
      endPoint: ApiEndpoints.leaveGroup(groupId: groupModel.id),
    );

    isLeaving.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      isJoined.value = false;
      postsHelper.items.clear();
      membersHelper.items.clear();
      displayMembers.clear();
      isPostsLoaded.value = false;
      isMembersLoaded.value = false;
      tabController.index = 0;
    }
  }




  // ====== SEND WAVE ======
  Future<void> sendWave({required String userId}) async {

    final member = displayMembers.firstWhereOrNull((m) => m.userId == userId);

    if( member == null || member.isWaveLoading.value ){
      return;
    }
    member.isWaveLoading.value = true;

    final Map<String, String> payLoad = {
      "receiver": userId
    };

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.sendWave,
      body: payLoad
    );

    member.isWaveLoading.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      member.isWavePending = true;
    }else{
      showApiSnackBar(
          statusCode: response.statusCode
      );
    }
  }

  Future<void> waveBack({required String userId}) async{

    final member = displayMembers.firstWhereOrNull((m) => m.userId == userId);

    if( member == null || member.isWaveLoading.value ){
      return;
    }
    member.isWaveLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.waveBack(userId: userId),
      shouldPrint: true
    );

    member.isWaveLoading.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      member.isWavePending = false;
      member.isIncomingWave = false;
      member.isMatched = true;
    }else{
      showApiSnackBar(
          statusCode: response.statusCode,
        data: response.data
      );
    }
  }

  //==================LIKE/UNLIKE POST==========================
  Future<void> likeUnlikePost({required String postId}) async{

    if( isLikeLoading.value ){
      return;
    }

    isLikeLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.groupPostLikeUnlike( postId: postId )
    );

    isLikeLoading.value = false;

    if( response.statusCode == 200 ){
      final post = postsHelper.items.firstWhereOrNull((p) => p.id == postId);
      if( post != null ){
        post.isLikedByMe = !post.isLikedByMe;
        post.likesCount = post.isLikedByMe ? post.likesCount + 1 : post.likesCount - 1;
        postsHelper.items.refresh();
      }
    }
  }

  //====================DELETE POST=============================
  Future<void> deletePost({required String postId}) async{

    showDeletingAlert();
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: ApiEndpoints.deleteGroupPost(postId: postId)
    );

    if( Get.isDialogOpen ?? false ){
      Get.back();
    }

    if( response.statusCode == 200 ){
      postsHelper.items.removeWhere((p) => p.id == postId);
      postsHelper.items.refresh();
    }
  }

  //OPEN website LINK IN BROWSER
  Future<void> openLinkInBrowser({required String websiteLink}) async {
    final Uri? url = Uri.tryParse(websiteLink);

    if (url == null || !url.hasScheme) {
      //showSnackBar(title: "Cannot open", message: "Invalid URL format", backgroundColor: AppColors.errorRed);
      return;
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        //showSnackBar(title: "Failed", message: "No application found to handle this link.", backgroundColor: AppColors.errorRed);
      }
    } catch (e) {
      //showSnackBar(title: "Cannot open link", message: "Error launching URL", backgroundColor: AppColors.errorRed);
    }
  }


//DELETE ACCOUNT DIALOG
  void showDeleteDialog({required String postId}) async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              Text(
                "Delete post",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete this post?",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.inactiveGray, width: 2.r)
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async{
                        Get.back();
                        deletePost( postId: postId );
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  //DELETING ALERT
  Future<void> showDeletingAlert() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),),
              SizedBox(
                height: 15.h,
              ),
              Text("Deleting...", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),)
            ],
          ),
        )
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    postScrollController.dispose();
    membersScrollController.dispose();
    searchController.dispose();
    if ( _debounce?.isActive ?? false ) _debounce!.cancel();
    super.onClose();
  }
}