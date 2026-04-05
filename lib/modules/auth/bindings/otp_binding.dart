import 'package:get/get.dart';
import 'package:pcs_village/modules/auth/controllers/otp_verify_controller.dart';

class OtpBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<OtpVerifyController>(() => OtpVerifyController(), fenix: true);
  }
}