import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_date_picker.dart';
import 'package:pcs_village/modules/auth/controllers/signup_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';

class SignupFiveScreen extends StatelessWidget {
  SignupFiveScreen({super.key});

  final SignupController controller = Get.find<SignupController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 20),
            child: Text("Step 5 of 5", style: TextStyle(color: Colors.grey)),
          )
        ],
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
                  value: 1, // 5 of 5
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'PCS Timeline',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B365D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'When are you planning to PCS to your new duty station?',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              CustomDatePicker(
                validator: (datetime){
                  if( datetime == null ){
                    return 'Please select a date';
                  }else{
                    return null;
                  }
                },
                  label: "Select moving date",
                  onDateSelected: (datetime){
                    if( datetime != null ){
                      controller.movingTime = datetime;
                    }
                  },
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  initialYear: DateTime.now().year,
                  firstYear: DateTime.now().year,
                  lastYear: DateTime.now().year + 1,
              ),
              const Spacer(),
              // Bottom Action Button
              CustomButton(
                  label: AppStrings.completeSetup,
                onPressed: (){
                    if( _formKey.currentState!.validate() ){
                      //Get.toNamed(AppRoutes.mainNav);
                      controller.signup();
                    }
                },
              ),
              const SizedBox( height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}