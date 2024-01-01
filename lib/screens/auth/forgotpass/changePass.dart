import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/forgotpassword/changepasswordform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../../../helper/state/state_manager.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
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
                    text: "Change Password",
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  ChangePasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
