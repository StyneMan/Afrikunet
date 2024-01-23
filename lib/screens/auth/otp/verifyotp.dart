import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/layout/appbar/appbar.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/auth/forgotpass/changePass.dart';

import '../../../helper/state/state_manager.dart';

typedef void InitCallback(params);

class VerifyOTP extends StatefulWidget {
  String email;
  String caller;
  VerifyOTP({Key? key, required this.email, required this.caller})
      : super(key: key);

  @override
  State<VerifyOTP> createState() => _State();
}

class _State extends State<VerifyOTP> {
  final _controller = Get.find<StateController>();
  final _otpController = TextEditingController();
  // final _phoneController = TextEditingController();
  String _code = '';
  bool _shouldContinue = false;
  CountdownTimerController? _timerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;

  @override
  void initState() {
    super.initState();
    _timerController?.start();
    // Future.delayed(const Duration(minutes: 5), () {
    //   _timerController?.start();
    // });
  }

  // _resendCode() async {
  //   _controller.setLoading(true);
  //   try {
  //     final resp =
  //         await APIService().resendOTP(email: widget.email, type: "register");
  //     debugPrint("RESEND OTP RESPONSE:: ${resp.body}");
  //     _controller.setLoading(false);
  //     if (resp.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       Constants.toast(map['message']);
  //     } else {
  //       Map<String, dynamic> map = jsonDecode(resp.body);
  //       Constants.toast(map['message']);
  //     }
  //   } catch (e) {
  //     _controller.setLoading(false);
  //   }
  //   // }
  // }

  @override
  void dispose() {
    super.dispose();
    _timerController?.dispose();
  }

  _pluralizer(num) {
    return num < 10 ? "0$num" : "$num";
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              width: double.infinity,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/bg.png'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextSmall(
                            text: widget.caller == "voucher"
                                ? "A verification code has been sent to ${widget.email}"
                                : "Enter the code sent to ${widget.email}",
                            align: TextAlign.center,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CountdownTimer(
                          controller: _timerController,
                          endTime: endTime,
                          widgetBuilder: (_, CurrentRemainingTime? time) {
                            if (time == null) {
                              return const SizedBox();
                            }
                            return TextMedium(
                              text:
                                  ' ${_pluralizer(time.min ?? 0) ?? "0"} : ${_pluralizer(time.sec ?? 0)}',
                              align: TextAlign.center,
                              color: Theme.of(context).colorScheme.tertiary,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Center(
                          child: SizedBox(
                            width: 320,
                            child: PinCodeTextField(
                              appContext: context,
                              backgroundColor: Colors.transparent,
                              pastedTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
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
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                fieldHeight: 60,
                                fieldWidth: 56,
                                activeFillColor:
                                    Theme.of(context).colorScheme.tertiary,
                                activeColor: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                inactiveColor: Colors.black45,
                              ),
                              cursorColor:
                                  Theme.of(context).colorScheme.tertiary,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              // enableActiveFill: true,
                              // errorAnimationController: errorController,
                              controller: _otpController,
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
                                setState(() {
                                  _shouldContinue = true;
                                });
                                debugPrint("Completed");
                              },
                              onChanged: (value) {
                                if (value.length < 4) {
                                  setState(() {
                                    _shouldContinue = false;
                                  });
                                }
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
                        const SizedBox(
                          height: 36,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            buttonText: "Continue",
                            onPressed: _shouldContinue
                                ? () {
                                    _controller.setLoading(true);
                                    Future.delayed(
                                      const Duration(seconds: 3),
                                      () {
                                        _controller.setLoading(false);
                                        if (widget.caller == "signup") {
                                          Get.to(
                                            const Dashbboard(),
                                            transition: Transition.cupertino,
                                          );
                                        } else if (widget.caller == "voucher") {
                                          Get.to(
                                            const SuccessPage(
                                              isVoucher: true,
                                            ),
                                            transition: Transition.cupertino,
                                          );
                                        } else if (widget.caller == "2fa") {
                                          // Show dialog here ...
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                InfoDialog(
                                              body: SingleChildScrollView(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 24.0,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/images/check_all.svg",
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface,
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      TextSmall(
                                                        text:
                                                            "2FA successfully enabled. You can now login with 2FA.",
                                                        align: TextAlign.center,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        width: double.infinity,
                                                        child: PrimaryButton(
                                                          buttonText: "Done",
                                                          fontSize: 15,
                                                          onPressed: () {
                                                            Get.back();
                                                            Get.back();
                                                            Get.back();
                                                            Get.back();
                                                            Get.back();
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Get.to(
                                            const ChangePassword(),
                                            transition: Transition.cupertino,
                                          );
                                        }
                                      },
                                    );
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextSmall(
                              text: "Didn't receive?",
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            // _timerController.currentRemainingTime == null
                            //     ?
                            TextButton(
                              onPressed: () {
                                _controller.setLoading(true);
                                Future.delayed(
                                  const Duration(seconds: 3),
                                  () {
                                    _controller.setLoading(false);
                                    Constants.toast(
                                        "OTP has been resent to ${widget.email}");
                                  },
                                );
                              },
                              child: TextSmall(
                                text: "Resend Code ",
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                              ),
                            ),
                            // : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
