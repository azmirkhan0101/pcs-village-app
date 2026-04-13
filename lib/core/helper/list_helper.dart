import 'package:get/get.dart';

import '../utils/api_response.dart';
import '../utils/show_snackbar.dart';

class ListHelper<T> {

  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetch({
    required Future<ApiResponse> Function() apiCall,
    required T Function(dynamic json) fromJson,
    required List<dynamic>? Function(dynamic responseData) listExtractor,
    bool showMessage = false
  }) async {

    if (isLoading.value) return;

    isLoading.value = true;

    final response = await apiCall();

    isLoading.value = false;

    if (showMessage) {
      showApiSnackBar(
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.statusCode == 200) {
      final tempList = listExtractor(response.data);

      if (tempList != null) {
        final fetched = tempList.map(fromJson).toList();
        items.assignAll(fetched);
      } else {
        items.clear();
      }
    }
  }
}