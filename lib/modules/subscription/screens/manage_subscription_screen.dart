import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/modules/subscription/controllers/manage_subsciption_controller.dart';
import 'package:pcs_village/modules/subscription/widgets/history_card.dart';

import '../../../data/models/subscription/history_model.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  ManageSubscriptionScreen({super.key});

  final ManageSubscriptionController controller = Get.find<ManageSubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          'Manage Subscription',
          style: TextStyle(color: Color(0xFF344767), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx((){
              if( controller.isActivePlanLoading.value ){
                return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
              }else if( !controller.isActivePlanLoading.value && controller.activePlanModel.value == null ){
                return Center(child: Text("No active plan found"),);
              }
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF425A7D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.workspace_premium, color: Colors.orangeAccent),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Premium Membership',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                                SizedBox(width: 4),
                                Text('Active', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 40, color: Colors.white24),
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(text: controller.activePlanModel.value., style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    //       TextSpan(text: '/month', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // --- Benefits Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F0), // Light beige background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Premium Benefits',
                      style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildBenefitItem('Unlimited direct messages'),
                  _buildBenefitItem('Create posts in community feed'),
                  _buildBenefitItem('Comment on all posts'),
                  _buildBenefitItem('Full access to base communities'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Billing History Card ---
            Container(
              height: 250,
              child: _buildWhiteCard([
                const Text('Billing History',
                    style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Obx((){
                  if( controller.isPlanHistoryLoading.value ){
                    return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                  }else if( controller.historyList.isEmpty ){
                    return Center(child: Text("No history found"),);
                  }else{
                    return ListView.builder(
                        itemCount: controller.historyList.length,
                        itemBuilder: (context, index){

                          final HistoryModel history = controller.historyList[index];

                          return HistoryCard(
                              title: DateFormat("dd MM YYYY").format(history.createdAt.toLocal()),
                              subtitle: "Paid on ${DateFormat("dd MM YYYY").format(history.createdAt.toLocal())}",
                              amount: history.planPrice.toString()
                          );
                        }
                    );
                  }
                })
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildWhiteCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {String? trailing}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.green[700], size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F), fontSize: 15)),
            ],
          ),
        ),
        if (trailing != null)
          Text(trailing, style: const TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Color(0xFF425A7D), fontSize: 14)),
        ],
      ),
    );
  }
}