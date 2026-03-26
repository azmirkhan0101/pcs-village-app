import 'package:get/get.dart';


// GetPage(
// name: AppRoutes.mainNav,
// page: (){
// return MainNavScreen();
// }
// ),


class MainNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}