
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/modules/profile/controllers/base_request_controller.dart';

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
                      _buildTextField(
                        controller: controller.baseNameController,
                        label: 'Base Name',
                        hint: 'Enter base name',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.cityController,
                        label: 'City',
                        hint: 'Enter city',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.stateController,
                        label: 'State',
                        hint: 'Enter state',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.countryController,
                        label: 'Country',
                        hint: 'Enter country',
                      ),
                    ],
                  ),
                ),
              ),
              Obx((){
                return CustomButton(label: "Submit",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }
}