import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/api_response.dart';
import '../utils/show_snackbar.dart';

class PaginationHelper<T> {
  final RxList<T> _items = <T>[].obs;

  RxList<T> get items => _items;

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;

  int currentPage = 1;
  bool hasMore = true;

  //CONFIGS
  late Future<ApiResponse> Function(int page) _apiCall;
  late T Function(dynamic json) _fromJson;
  late List<dynamic>? Function(dynamic data) _listExtractor;

  int _pageSize = 10;
  bool _showMessage = false;

  void init({
    required Future<ApiResponse> Function(int page) apiCall,
    required T Function(dynamic json) fromJson,
    required List<dynamic>? Function(dynamic data) listExtractor,
    int pageSize = 10,
    bool showMessage = false,
  }) {
    _apiCall = apiCall;
    _fromJson = fromJson;
    _listExtractor = listExtractor;
    _pageSize = pageSize;
    _showMessage = showMessage;
  }

  Future<void> fetch({required bool isRefresh}) async {
    if (isLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      isLoading.value = true;
      _items.clear();
    } else {
      if (isMoreLoading.value || !hasMore) return;
      isMoreLoading.value = true;
    }

    final response = await _apiCall(currentPage);

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
          _items.assignAll(fetched);
        } else {
          _items.addAll(fetched);
        }

        if (fetched.length < _pageSize) {
          hasMore = false;
        } else {
          currentPage++;
        }
      }
    }
  }

  void attachScrollController(ScrollController controller) {
    controller.addListener(() {
      if (!controller.hasClients) return;

      if (controller.position.pixels >=
          controller.position.maxScrollExtent * 0.9) {
        fetch(isRefresh: false);
      }
    });
  }
}
