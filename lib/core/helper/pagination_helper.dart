import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';

import '../utils/show_snackbar.dart';

class PaginationHelper<T> {

  //==============API SERVICE CLASS==============
  final ApiService _apiService = Get.find<ApiService>();

  //================REACTIVE LIST================
  final RxList<T> items = <T>[].obs;
  //================LOADING STATES===============
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  //================PAGINATION===================
  int currentPage = 1;
  bool hasMore = true;

  //CONFIGS
  String _method = "GET";
  late String Function(int page) _endPoint;
  bool _isAuthRequired = true;
  late T Function(dynamic json) _fromJson;
  late List<dynamic>? Function(dynamic data) _listExtractor;
  int _pageSize = 10;
  bool _showMessage = false;

  void init({
    String method = "GET",
    required String Function(int page) endPoint,
    bool isAuthRequired = true,
    required T Function(dynamic json) fromJson,
    required List<dynamic>? Function(dynamic data) listExtractor,
    int pageSize = 10,
    bool showMessage = false,
    ScrollController? scrollController
  }) {
    _method = method;
    _endPoint = endPoint;
    _isAuthRequired = isAuthRequired;
    _fromJson = fromJson;
    _listExtractor = listExtractor;
    _pageSize = pageSize;
    _showMessage = showMessage;

    //==============Attach scroll listener==================
    if (scrollController != null) {
      scrollController.addListener(() {
        if (!scrollController.hasClients) return;

        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent * 0.9) {
          fetch(isRefresh: false);
        }
      });
    }
  }

  //==============PAGINATED API CALL==================
  Future<void> fetch({required bool isRefresh}) async {
    if (isLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      isLoading.value = true;
      items.clear();
    } else {
      if (isMoreLoading.value || !hasMore) return;
      isMoreLoading.value = true;
    }

    final response = await _apiService.networkRequest(
        method: _method,
        isAuthRequired: _isAuthRequired,
        endPoint: _endPoint(currentPage)
    );

    isLoading.value = false;
    isMoreLoading.value = false;

    if (_showMessage) {
      showApiSnackBar(statusCode: response.statusCode, data: response.data);
    }

    if (response.statusCode == 200) {
      final tempList = _listExtractor(response.data);

      if (tempList != null && tempList.isNotEmpty) {
        final fetched = tempList.map(_fromJson).toList();

        if (isRefresh) {
          items.assignAll(fetched);
        } else {
          items.addAll(fetched);
        }

        if (fetched.length < _pageSize) {
          hasMore = false;
        } else {
          currentPage++;
        }
      }
    }
  }
}
