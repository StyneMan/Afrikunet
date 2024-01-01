import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/cards/giftcard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmPurchase extends StatefulWidget {
  const ConfirmPurchase({Key? key}) : super(key: key);

  @override
  State<ConfirmPurchase> createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            title: TextMedium(
              text: "Confirm Purchase",
              color: Colors.black,
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16.0),
                Text(
                  "Purchase Info",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32.0),
                const SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: GiftCard(
                    width: double.infinity,
                    amount: "100,000",
                    bgImage: "assets/images/giftcard_bg.png",
                    code: "XDT12IUNWpo1HN",
                    logo: "assets/images/logo_blue.png",
                    type: "white",
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(
                  "Alt email for 2FA",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  placeholder: "Enter a valid email",
                  onChanged: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        _isValidEmail = false;
                      });
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                        .hasMatch(value)) {
                      setState(() {
                        _isValidEmail = false;
                      });
                    } else {
                      setState(() {
                        _isValidEmail = true;
                      });
                    }
                  },
                  endIcon: _isValidEmail
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : const Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.red,
                        ),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                PrimaryButton(
                  fontSize: 18,
                  buttonText: "Confirm",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showOTPDialog();
                    }
                  },
                ),
              ],
            ),
          ),
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
