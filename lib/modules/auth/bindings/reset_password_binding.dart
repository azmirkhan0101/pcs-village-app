import 'package:get/get.dart';
import 'package:pcs_village/modules/auth/controllers/forgot_password_controller.dart';
import 'package:pcs_village/modules/auth/controllers/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(), fenix: true);
  }
}