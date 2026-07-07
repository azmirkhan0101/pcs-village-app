import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/data/models/auth/duty_station_model.dart';
import 'package:pcs_village/modules/auth/controllers/duty_stations_controller.dart';
import 'package:pcs_village/modules/auth/controllers/signup_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/extensions.dart';

class SignupFourScreen extends StatelessWidget {
  SignupFourScreen({super.key});

  final SignupController controller = Get.find<SignupController>();
  final DutyStationsController stationsController = Get.find<DutyStationsController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    WidgetsBinding.instance.addPostFrameCallback((_){
      stationsController.searchStation(query: "", isCurrent: true);
      stationsController.searchStation(query: "", isCurrent: false);
    });

    const Color primaryColor = Color(0xFF1D3557);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        centerTitle: false,
        actions:  [
          Text(
            'Step 4 of 5',
            style: TextStyle(color: Colors.grey, fontSize: isTab ? 10.sp : 14),
          ),
          SizedBox(width: 20),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.8, // 4 of 5
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 40),

              // Header Text
              const Text(
                'Select Duty Stations',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                'Choose your current and future duty stations',
                style: TextStyle(fontSize: isTab ? 12.sp : 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Form Fields
              CustomTextField(
                label: 'Current Duty Station',
                hintText: 'Search current station',
                controller: controller.currentStationController,
                onChanged: (value){
                  stationsController.searchStation(query: value, isCurrent: true);
                },
                validator: (value){
                  if( controller.currentStationId == null ){
                    return 'Please select current station';
                  }else{
                    return null;
                  }
                },
              ),
              const SizedBox( height: 10,),
              Obx((){
                if( stationsController.currentStationResults.isEmpty && !stationsController.isCurrentLoading.value ){
                  return const SizedBox.shrink();
                }
                return searchResults(stationsController.currentStationResults, true, isTab: isTab);
              }),
              const SizedBox( height: 20,),
              CustomTextField(
                label: 'Future Duty Station',
                hintText: 'Search future station',
                controller: controller.futureStationController,
                onChanged: (value){
                  stationsController.searchStation(query: value, isCurrent: false);
                },
              ),
              const SizedBox( height: 10,),
              Obx((){
                if( stationsController.futureStationResults.isEmpty && !stationsController.isFutureLoading.value ){
                  return const SizedBox.shrink();
                }else{
                  return searchResults(stationsController.futureStationResults, false, isTab: isTab);
              }}),
              const SizedBox( height: 20,),
              const Spacer(),
              // Continue Button
              Center(
                child: CustomButton(
                  label: AppStrings.cContinue,
                  onPressed: (){
                      if( _formKey.currentState!.validate() ){
                        Get.toNamed(AppRoutes.signupStepFiveScreen);
                      }
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchResults(List<DutyStationModel> results, bool isCurrent, {required bool isTab}) {

    return Container(
      height: 250,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index].name, style: TextStyle(fontSize: isTab ? 10.sp : null),),
            onTap: () {
              if (isCurrent) {
                controller.currentStationId = results[index].id;
                controller.currentStationController.text = results[index].name;
                stationsController.currentStationResults.clear();
              } else {
                controller.futureStationId = results[index].id;
                controller.futureStationController.text = results[index].name;
                stationsController.futureStationResults.clear();
              }
            },
          );
        },
      ),
    );
  }
}