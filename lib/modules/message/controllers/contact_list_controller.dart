import 'package:get/get.dart';

import '../../../core/services/api_service.dart';

class ContactListController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  RxBool isContactListLoading = false.obs;
}