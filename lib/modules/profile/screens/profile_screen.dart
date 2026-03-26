import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  //final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("Profile"),
      ),
    );
  }

  //SHOW LOGOUT DIALOG
  // Future<void> showLogOutDialog() async{
  //   Get.dialog(
  //       AlertDialog(
  //         backgroundColor: AppColors.greyB2,
  //         content: Column(
  //           spacing: 5,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Center(
  //               child: Container(
  //                 padding: EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: CupertinoColors.destructiveRed,
  //                   shape: BoxShape.circle,
  //                   //borderRadius: BorderRadius.circular(100)
  //                 ),
  //                 child: Icon(Icons.exit_to_app, color: AppColors.white, fontWeight: FontWeight.bold, size: 28,),
  //               ),
  //             ),
  //             const TextWidget(
  //               text: AppStrings.logOut,
  //               fontColor: AppColors.secondaryDarkBlue,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             const TextWidget(
  //               text: AppStrings.doYouWantToLogOut,
  //               fontColor: AppColors.grey4E,
  //               fontSize: 14,
  //             )
  //           ],
  //         ),
  //         actionsAlignment: MainAxisAlignment.spaceBetween,
  //         actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         actions: [
  //           Row(
  //             spacing: 4,
  //             children: [
  //               Expanded(
  //                 child: ButtonWidget(
  //                   buttonHeight: 40,
  //                   label: AppStrings.cancel,
  //                   fontSize: 14,
  //                   backgroundColor: AppColors.secondaryDarkBlue,
  //                   onPressed: (){
  //                     Get.back();
  //                   },
  //                 ),
  //               ),
  //               Expanded(
  //                 child: ButtonWidget(
  //                   buttonHeight: 40,
  //                   label: AppStrings.logOut,
  //                   fontSize: 14,
  //                   gradient: AppColors.primaryButtonGradient,
  //                   onPressed: (){
  //                     controller.logOut();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       )
  //   );
  // }
}
