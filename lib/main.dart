import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/main_app.dart';
import 'package:pcs_village/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:pcs_village/modules/auth/screens/otp_verify_screen.dart';

import 'core/services/api_service.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync(() => ApiService().init());

  runApp(MainApp());
}