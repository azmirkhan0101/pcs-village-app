
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/settings/controllers/base_request_controller.dart';

class BaseRequestScreen extends StatelessWidget {
  BaseRequestScreen({super.key});

  final BaseRequestController controller = Get.find<BaseRequestController>();

  // Global key for the form to handle validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Location Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Base Name',
                        controller: controller.baseNameController,
                        hintText: 'Enter base name',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'City',
                        controller: controller.cityController,
                        hintText: 'Enter city',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'State',
                        controller: controller.stateController,
                        hintText: 'Enter state',

                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Country',
                        controller: controller.countryController,
                        hintText: 'Enter country',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Obx((){
                return CustomButton(
                  label: "Submit",
                isLoading: controller.isLoading.value,
                  onPressed: (){
                    if( _formKey.currentState!.validate() ){
                      controller.requestBase();
                    }
                  },
                );
              }),
              // Submit Button at the bottom
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}