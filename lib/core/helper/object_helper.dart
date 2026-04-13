import 'package:get/get.dart';

import '../utils/api_response.dart';
import '../utils/show_snackbar.dart';

class ObjectHelper<T> {

  final Rxn<T> item = Rxn<T>();
  final RxBool isLoading = false.obs;

  Future<void> fetch({
    required Future<ApiResponse> Function() apiCall,
    required T Function(dynamic json) fromJson,
    required dynamic Function(dynamic responseData) dataExtractor,
    Function(T data)? onSuccess,
    Function(ApiResponse response)? onError,
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

      final extractedData = dataExtractor(response.data);

      if (extractedData != null) {
        final parsedData = fromJson(extractedData);

        item.value = parsedData;
        if (onSuccess != null) {
          onSuccess(parsedData);
        }

      } else {
        item.value = null;
        if (onError != null) {
          onError(response);
        }
      }

    } else {
      if (onError != null) {
        onError(response);
      }
    }
  }
}