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

  Future<void> fetch({
    required bool isRefresh,
    required Future<ApiResponse> Function(int page) apiCall,
    required T Function(dynamic json) fromJson,
    required List<dynamic>? Function(dynamic responseData) listExtractor,
    int pageSize = 10,
    bool showMessage = false
  }) async {

    if (isLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      isLoading.value = true;
    } else {
      if (isMoreLoading.value || !hasMore) return;
      isMoreLoading.value = true;
    }

    final response = await apiCall(currentPage);

    isLoading.value = false;
    isMoreLoading.value = false;

    if( showMessage ){
      showApiSnackBar(
          statusCode: response.statusCode,
          data: response.data
      );
    }

    if (response.statusCode == 200) {

      final tempList = listExtractor(response.data);

      if (tempList != null && tempList.isNotEmpty) {
        final fetched = tempList.map(fromJson).toList();

        if (isRefresh) {
          _items.assignAll(fetched);
        } else {
          _items.addAll(fetched);
        }

        if (fetched.length < pageSize) {
          hasMore = false;
        } else {
          currentPage++;
        }
      }
    }
  }
}