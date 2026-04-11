import 'package:get/get.dart';

import '../controllers/groups_details_controller.dart';

class GroupDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<GroupsDetailsController>(() => GroupsDetailsController(), fenix: true);
  }
}