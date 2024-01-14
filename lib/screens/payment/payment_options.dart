import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Text(
              "Payment Options",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _showOTPDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark_circle,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Center(
                child: Text(
                  "Enter Your Pin",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: 320,
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Colors.white,
                      pastedTextStyle: const TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      autoFocus: true,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1.25,
                        fieldOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        activeColor: Constants.primaryColor,
                        inactiveColor: Colors.black45,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      keyboardType: TextInputType.number,
                      boxShadows: null,
                      // const [
                      //   BoxShadow(
                      //     offset: Offset(0, 1),
                      //     color: Colors.black12,
                      //     blurRadius: 10,
                      //   )
                      // ],
                      onCompleted: (v) {
                        // setState(() {
                        //   _shouldContinue = true;
                        // });
                        debugPrint("Completed");
                        Get.back();
                        _controller.isLoading.value = true;
                        Future.delayed(const Duration(seconds: 3), () {
                          _controller.isLoading.value = false;

                          Get.to(
                            const SuccessPage(),
                            transition: Transition.cupertino,
                          );
                        });
                      },
                      onChanged: (value) {
                        // if (value.length < 4) {
                        //   setState(() {
                        //     _shouldContinue = false;
                        //   });
                        // }
                        debugPrint(value);
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      autoDismissKeyboard: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextBody1(
                  text: "Insert Pin to complete this purchase",
                  color: const Color(0xFF575757),
                  align: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 72,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
