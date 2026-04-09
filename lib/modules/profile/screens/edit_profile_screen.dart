import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';

import '../../../core/widgets/photo_edit_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final ProfileController controller = Get.find<ProfileController>();
  // Define colors based on the UI
  final Color primaryNavy = const Color(0xFF1D3557);
  final Color lightGrey = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        title: const Text("Edit Profile", style: TextStyle(color: Color(0xFF1D3557), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Obx((){
              return CustomButton(
                label: AppStrings.save,
                buttonRadius: 100,
                fontSize: 14,
                isLoading: controller.isEditProfileLoading.value,
                onPressed: (){
                  controller.updateProfile();
                },
              );
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture with Camera Icon
            Obx((){
              return PhotoEditWidget(
                imageUrl: controller.profileImageUrl.value,
                onImagePicked: (file){
                  controller.profileImage.value = file;
                },
              );
            }),
            const SizedBox(height: 30),
            CustomTextField(
              label: "Name",
              hintText: "your name",
              controller: controller.nameController,
              validator: (value){
                if( value == null || controller.nameController.text.trim().length < 3 ){
                  return "Please enter a valid name";
                }
                return null;
              },
            ),
            _buildLabel("Military Branch"),
            _buildDropdownField(["Army", "Navy", "Air Force", "Marines"]),

            _buildLabel("Military Affiliation"),
            _buildTextField(""),

            // Interest Section
            _buildLabel("Interests"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip("Fitness", isSelected: true),
                _buildChip("Cooking", isSelected: true),
                _buildChip("Reading", isSelected: true),
                _buildChip("Travel", isSelected: true),
                _buildChip("Photography"),
                _buildChip("Sports"),
                _buildChip("Arts & Crafts"),
                _buildChip("Music"),
                _buildChip("Gardening"),
              ],
            ),
            const SizedBox(height: 24),

            // Age Range Section
            _buildLabel("Kids Age Range"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip("0-2 years"),
                _buildChip("3-5 years", isSelected: true),
                _buildChip("6-12 years", isSelected: true),
                _buildChip("13-17 years"),
                _buildChip("18+ years"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: TextStyle(color: primaryNavy.withOpacity(0.8), fontWeight: FontWeight.w600)),
    );
  }

  // Custom Chip Widget
  Widget _buildChip(String label, {bool isSelected = false}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool value) {},
      labelStyle: TextStyle(color: isSelected ? Colors.white : primaryNavy, fontSize: 14),
      backgroundColor: Colors.white,
      selectedColor: primaryNavy,
      checkmarkColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      // To mimic the "X" in your image:
      deleteIcon: isSelected ? const Icon(Icons.close, size: 14, color: Colors.white) : null,
      onDeleted: isSelected ? () {} : null,
    );
  }

  // Custom Text Field
  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: lightGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  // Custom Dropdown
  Widget _buildDropdownField(List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: lightGrey, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.first,
          isExpanded: true,
          items: items.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}