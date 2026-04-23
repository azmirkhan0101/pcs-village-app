import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/show_snackbar.dart';


class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  //final String bookingId;
  //final bool isUpdatingSubscription;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    //required this.bookingId,
    //required this.isUpdatingSubscription,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  ProfileController profileController = Get.find<ProfileController>();
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            showSnackBar(title: "Error occurred!", message: "Error loading payment page", backgroundColor: AppColors.errorRed);
          },
          onNavigationRequest: (NavigationRequest request) {
            // Detect Stripe/checkout success URLs
            if (request.url.contains('activate-from-checkout')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            } else if (request.url.contains('success') || request.url.contains('payment-success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            } else if (request.url.contains('cancel') || request.url.contains('payment-cancel')) {
              _handlePaymentCancel();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentSuccess() async {
    profileController.getProfile();
    if (!mounted) return;
    showSuccessDialog();
    // if (mounted) {
    //   Get.offAllNamed( AppRoutes.mainNav );
    // }
  }


  //SHOW PAYMENT
  void showSuccessDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "Payment success!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const SizedBox.shrink(),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            //Okay button
            Center(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.greenPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Get.back();
                  },
                  child: const Text(
                    "Okay",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _handlePaymentCancel() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Payment was cancelled or failed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Payment',),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
