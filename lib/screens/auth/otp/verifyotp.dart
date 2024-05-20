import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/state/state_manager.dart';

typedef void InitCallback(params);

class VerifyOTP extends StatefulWidget {
  String email;
  String caller;
  String vtuType;
  final String? voucherCode;
  final Map? bankData;
  final PreferenceManager manager;
  VerifyOTP({
    Key? key,
    required this.email,
    required this.caller,
    required this.manager,
    this.bankData,
    this.voucherCode = "",
    this.vtuType = "topup",
  }) : super(key: key);

  @override
  State<VerifyOTP> createState() => _State();
}

class _State extends State<VerifyOTP> {
  final _controller = Get.find<StateController>();
  final _otpController = TextEditingController();
  // final _phoneController = TextEditingController();
  String _code = '';
  bool _shouldContinue = false, _showResend = false;
  CountdownTimerController? _timerController;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 1;

  @override
  void initState() {
    super.initState();
    _timerController?.start();
  }

  _resendOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    try {
      final Map _payload = {"email_address": widget.email};
      final resp = await APIService().resendOTP(_payload);
      debugPrint("RESEND OTP RESPONSE:: ${resp.body}");
      _controller.setLoading(false);
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
        setState(() {
          _showResend = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          _timerController?.start();
        });
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constants.toast(map['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
    }
    // }
  }

  _generateOTP() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      _controller.setLoading(true);
      _otpController.clear();
      final _response = await APIService().voucherGenerateOTP(
        accessToken: widget.manager.getAccessToken(),
        voucherCode: widget.voucherCode,
      );
      _controller.setLoading(false);
      print("SEND OTP RESPONSE HERE ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        Constants.toast(map['message']);
      }
    } catch (e) {
      _controller.setLoading(false);
      print("$e");
    }
  }

  _verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (widget.caller == "voucher") {
      _controller.setLoading(true);

      try {
        Map _payload = {
          "voucher_code": widget.voucherCode,
          "bank_account_number": widget.bankData?['account_number'],
          "bank_code": widget.bankData?['code'],
          "token": int.parse(_otpController.text),
        };

        // final _prefs = await SharedPreferences.getInstance();
        final _response = await APIService()
            .redeemVoucher(widget.manager.getAccessToken(), _payload);
        _controller.setLoading(false);
        debugPrint("REDEEM VOUCHER RESPONSE  ::: ${_response.body}");

        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> _map = jsonDecode(_response.body);
          Constants.toast(_map['message']);

          if (_map['status'] != "error") {
            Get.to(
              SuccessPage(
                isVoucher: true,
                manager: widget.manager,
              ),
              transition: Transition.cupertino,
            );
          }
        }
      } catch (e) {
        print("$e");
      }
    } else if (widget.caller == "vtu") {
      // Constants.toast("Waiting for Tolu to continue");
      _controller.setLoading(true);

      Map _payload = {
        'otpCode': _otpController.text.trim(),
        'voucher_code': widget.voucherCode,
      };

      try {
        final _response = await APIService().voucherVerifyOTP(
          accessToken: widget.manager.getAccessToken(),
          payload: _payload,
        );
        _controller.setLoading(false);
        print('VALIDAT VOUCHER OTP RESPINSE :::  ${_response.body}');
        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(_response.body);
          Constants.toast('${map['message']}');

          _purchaseInternationalVTU();
        }
      } catch (e) {
        debugPrint(e.toString());
        _controller.setLoading(false);
      }
    } else {
      _controller.setLoading(true);

      Map _payload = {
        "email_address": widget.email,
        "code": int.parse(_otpController.text),
      };

      try {
        final _prefs = await SharedPreferences.getInstance();
        final _response = await APIService().verifyOTP(_payload);
        _controller.setLoading(false);
        debugPrint("VERIFY RESPONSE :: ${_response.body}");
        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> _mapper = jsonDecode(_response.body);
          //Save user data and preferences
          String userData = jsonEncode(_mapper['user']);
          _prefs.setString("userData", userData);
          _controller.setUserData(_mapper['user']);
          widget.manager.setUserData(userData);
          widget.manager.saveAccessToken(_mapper['accessToken']);
          _prefs.setString("accessToken", _mapper['accessToken']);
          _controller.onInit();

          if (widget.caller == "signup") {
            _prefs.setBool("loggedIn", true);
            Get.to(
              Dashboard(manager: widget.manager),
              transition: Transition.cupertino,
            );
          } else if (widget.caller == "2fa") {
            // Show dialog here ...
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => InfoDialog(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 24.0,
                        ),
                        SvgPicture.asset(
                          "assets/images/check_all.svg",
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextSmall(
                          text:
                              "2FA successfully enabled. You can now login with 2FA.",
                          align: TextAlign.center,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
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
              ChangePassword(emailAddress: widget.email),
              transition: Transition.cupertino,
            );
          }
        } else {
          Map<String, dynamic> _errMap = jsonDecode(_response.body);
          Constants.toast("${_errMap['message']}");
        }
      } catch (e) {
        _controller.setLoading(false);
      }
    }
  }

  _purchaseInternationalVTU() async {
    _controller.setLoading(true);
    try {
      final _response = await APIService().processDepositVoucher(
          accessToken: widget.manager.getAccessToken(),
          voucherCode: "${widget.voucherCode}",
          payload: _controller.internationalTopupPayload.value,
          type: widget.vtuType);

      print("PROCESS VOUCHER RESPONSE ::: ${_response.body}");
      _controller.setLoading(false);

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        Constants.toast(
            '${map['message'] ?? map['response_description'] ?? map['status']}');

        if ('${map['status']}'.toLowerCase().contains('delivered') ||
            '${map['data']['status']}'.toLowerCase().contains('delivered')) {
          Get.to(
            SuccessPage(
              isVoucher: false,
              manager: widget.manager,
              message:
                  'You have successfully purchased ${_controller.internationalTopupPayload.value['serviceID']} worth of ${_controller.internationalTopupPayload.value['amount']} for ${_controller.internationalTopupPayload.value['phone']}',
            ),
            transition: Transition.cupertino,
          );
        }
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint("$e");
    }
  }

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
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Row(
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
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.64,
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
                          onEnd: () {
                            setState(() {
                              _showResend = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: PinCodeTextField(
                            appContext: context,
                            backgroundColor: Colors.transparent,
                            pastedTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                            textStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            length: 6,
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
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              fieldHeight: 60,
                              fieldWidth: 49,
                              activeFillColor:
                                  Theme.of(context).colorScheme.tertiary,
                              activeColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              inactiveColor: Colors.black45,
                            ),
                            cursorColor: Theme.of(context).colorScheme.tertiary,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            // enableActiveFill: true,
                            // errorAnimationController: errorController,
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            boxShadows: null,
                            onCompleted: (v) {
                              setState(() {
                                _shouldContinue = true;
                              });
                              debugPrint("Completed");
                              _verifyOtp();
                            },
                            onChanged: (value) {
                              if (value.length < 6) {
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
                        const SizedBox(
                          height: 48,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            buttonText: "Continue",
                            onPressed: _shouldContinue
                                ? () {
                                    _verifyOtp();
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        !_showResend
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextSmall(
                                    text: "Didn't receive?",
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  // _timerController.currentRemainingTime == null
                                  //     ?
                                  TextButton(
                                    onPressed: () {
                                      if (widget.caller == "voucher" ||
                                          widget.caller == "vtu") {
                                        // Voucher Resend Here
                                        _generateOTP();
                                      } else {
                                        _resendOtp();
                                      }
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
