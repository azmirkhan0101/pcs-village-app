import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';

import '../../../data/models/faq/faq_model.dart';
import '../controllers/faq_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final FaqController controller = Get.put(FaqController());

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('FAQs'),
      centerTitle: true,
      elevation: 0,
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Obx(() {
      if (controller.faqHelper.items.isEmpty) {
        return _buildEmpty();
      }

      if (controller.faqHelper.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
      }

      // List with optional bottom loader
      return RefreshIndicator(
        onRefresh: () => controller.fetchFaqs(),
        child: ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          // +1 for bottom loading indicator
          itemCount: controller.faqHelper.items.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.faqHelper.items.length) {
              return _buildBottomLoader();
            }
            return _buildFaqCard(controller.faqHelper.items[index]);
          },
        ),
      );
    });
  }

  // ── FAQ card ───────────────────────────────────────────────────────────
  Widget _buildFaqCard(FaqModel faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Text(
            'Q',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        title: Text(
          faq.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Text(
                  faq.answer,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom loader ──────────────────────────────────────────────────────
  Widget _buildBottomLoader() {
    return Obx(() {
      if (controller.faqHelper.isMoreLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return const SizedBox.shrink();
    });
  }

  // ── Empty widget ───────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.help_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No FAQs found.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}