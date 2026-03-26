import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/main_app.dart';
import 'package:pcs_village/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:pcs_village/modules/recovery/screens/otp_verify_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(OtpController());
  Get.put(MainNavController());
  runApp(MainApp());
}