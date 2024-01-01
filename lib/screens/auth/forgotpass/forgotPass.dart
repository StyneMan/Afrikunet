import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/forgotpassword/passwordform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../../../helper/state/state_manager.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _controller = Get.find<StateController>();

  // PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    // _manager = PreferenceManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  TextLarge(
                    text: "Forgot password?",
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextBody1(
                    text:
                        "Enter email you used in signing up and we will help you reset your password",
                    align: TextAlign.center,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  const PasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
