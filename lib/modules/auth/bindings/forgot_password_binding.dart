import 'package:get/get.dart';
import 'package:pcs_village/modules/auth/controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);
  }
}