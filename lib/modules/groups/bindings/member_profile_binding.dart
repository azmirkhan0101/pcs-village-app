import 'package:get/get.dart';
import 'package:pcs_village/modules/groups/controllers/member_profile_controller.dart';

class MemberProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MemberProfileController>(() => MemberProfileController(), fenix: true);
  }
}