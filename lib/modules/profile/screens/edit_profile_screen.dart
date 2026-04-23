import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/photo_edit_widget.dart';
import '../../../data/models/auth/branch_model.dart';
import '../../../data/models/auth/duty_station_model.dart';
import '../../auth/controllers/duty_stations_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final ProfileController controller = Get.find<ProfileController>();
  final DutyStationsController stationsController = Get.isRegistered<DutyStationsController>()
  ? Get.find<DutyStationsController>() : Get.put(DutyStationsController());
  // Define colors based on the UI
  final Color primaryNavy = const Color(0xFF1D3557);
  final Color lightGrey = const Color(0xFFF8F9FA);
  List<String> affiliations = [
    Affiliation.activeDutySpouse.displayName,
    Affiliation.activeDuty.displayName,
    Affiliation.veteran.displayName,
    Affiliation.militaryFamily.displayName
  ];
  final List<String> _options = [
    KidsAgeRange.infant.displayName,
    KidsAgeRange.toddler.displayName,
    KidsAgeRange.preSchool.displayName,
    KidsAgeRange.schoolAge.displayName,
    KidsAgeRange.teenager.displayName
  ];

  void _toggleOption(String option) {
    final String optionValue = KidsAgeRange.values
        .firstWhere((element) => element.displayName == option)
        .value;

    setState(() {
      if (controller.kidsAgeRange.contains(optionValue)) {
        controller.kidsAgeRange.remove(optionValue);
      } else {
        controller.kidsAgeRange.add(optionValue);
      }
    });
  }

  String? branchError;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.getBranches();
    });

    super.initState();
  }

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
                controllerImage: controller.profileImage.value,
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
            Obx((){
              return _buildDropdownField(
                  hint: "Select Branch",
                  value: controller.selectedBranch.value,
                  errorText: branchError,
                  items: controller.branches.value.map((e){
                    return e.name;
                  }).toList(),
                  onChanged: (String? value) {
                    if( value == null ) return;
                    setState(() {
                      BranchModel model = controller.branches[controller.branches.indexOf(controller.branches.firstWhere((element) => element.name == value))];
                      controller.selectedBranch.value = value;
                      controller.selectedBranchId.value = model.id;
                    });
                  }
              );
            }),

            _buildLabel("Military Affiliation"),
            _buildDropdownField(
                hint: "Select Affiliation",
                value: controller.selectedAffiliation.value,
                items: affiliations,
                errorText: null,
                onChanged: (String? value) {
                  if( value == null ){
                    return;
                  }
                  setState(() {
                    controller.selectedAffiliation.value = value;
                  });
                }
            ),

            //Interest Section
            _buildLabel("Interests"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableInterests.map((interest) {
                return _buildChip(interest,isAgeRangeChip: false );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Age Range Section
            _buildLabel("Kids Age Range"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options.map((ageRange) {
                return _buildChip(ageRange, isAgeRangeChip: true);
              }).toList(),
            ),
            const SizedBox(height: 20,),
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
              return searchResults(stationsController.currentStationResults, true);
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
                return searchResults(stationsController.futureStationResults, false);
              }}),
            const SizedBox(height: 20,),
            CustomDatePicker(
              label: "Select moving date",
              initialDate: controller.pcsTimeline?.toLocal(),
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
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  Widget searchResults(List<DutyStationModel> results, bool isCurrent) {
    return Container(
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
            title: Text(results[index].name),
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

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: TextStyle(color: primaryNavy.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
    );
  }

  // Custom Chip Widget
  Widget _buildChip(String label, {required bool isAgeRangeChip}) {
    return Obx(() {
      final bool isSelected = isAgeRangeChip
          ? controller.kidsAgeRange.contains(KidsAgeRange.values.firstWhere((e) => e.displayName == label).value)
          : controller.selectedInterests.contains(label);
      //final bool isSelected = controller.selectedInterests.contains(label);

      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) => isAgeRangeChip
        ? _toggleOption(label)
        : controller.toggleInterestSelection(label),
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : primaryNavy,
            fontSize: 14
        ),
        backgroundColor: Colors.white,
        selectedColor: primaryNavy,
        checkmarkColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),

        // The "X" icon logic
        deleteIcon: isSelected
            ? const Icon(Icons.close, size: 14, color: Colors.white)
            : null,
        onDeleted: isSelected
            ? () => isAgeRangeChip ? _toggleOption(label) : controller.toggleInterestSelection(label)
            : null,
      );
    });
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? errorText,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: value,
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: onChanged,
      // Styling the dropdown to match your previous design
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        errorText: errorText,
        // The error message shows here
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.lightBlueAccent),
        ),
      ),
    );
  }
}