import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/inputfield/passwordfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();

  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  _changePass() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    Future.delayed(const Duration(seconds: 3), () {
      _controller.setLoading(false);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => InfoDialog(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24.0),
                  SvgPicture.asset("assets/images/check_all.svg"),
                  const SizedBox(height: 10.0),
                  TextSmall(
                    text:
                        "Password Successfully Changed. You will be required to login again.",
                    align: TextAlign.center,
                    fontWeight: FontWeight.w400,
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
                        Get.off(
                          const Login(),
                          transition: Transition.cupertino,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
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
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
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
                TextHeading(
                  text: "Change Password",
                  color: Colors.black,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextBody1(
                  text: "Old Password",
                  color: const Color(0xFF010101),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                PasswordField(
                  onChanged: (value) {
                    if (value.contains(RegExp(r'[0-9]'))) {
                      setState(() {
                        _isNumberOk = true;
                      });
                    } else {
                      setState(() {
                        _isNumberOk = false;
                      });
                    }

                    if (value.contains(RegExp(r'[A-Z]'))) {
                      setState(() {
                        _isCapitalOk = true;
                      });
                    } else {
                      setState(() {
                        _isCapitalOk = false;
                      });
                    }

                    if (value.contains(RegExp(r'[a-z]'))) {
                      setState(() {
                        _isLowercaseOk = true;
                      });
                    } else {
                      setState(() {
                        _isLowercaseOk = false;
                      });
                    }

                    if (value
                        .contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                      setState(() {
                        _isSpecialCharOk = true;
                      });
                    } else {
                      setState(() {
                        _isSpecialCharOk = false;
                      });
                    }
                  },
                  controller: _oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    if (value.toString().length < 8) {
                      return "Password must be at least 8 characters!";
                    }
                    if (!_isNumberOk ||
                        !_isCapitalOk ||
                        !_isLowercaseOk ||
                        !_isSpecialCharOk) {
                      return 'Weak password. See hint below';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextBody1(
                  text: "New Password",
                  color: const Color(0xFF010101),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                PasswordField(
                  onChanged: (value) {
                    if (value.contains(RegExp(r'[0-9]'))) {
                      setState(() {
                        _isNumberOk = true;
                      });
                    } else {
                      setState(() {
                        _isNumberOk = false;
                      });
                    }

                    if (value.contains(RegExp(r'[A-Z]'))) {
                      setState(() {
                        _isCapitalOk = true;
                      });
                    } else {
                      setState(() {
                        _isCapitalOk = false;
                      });
                    }

                    if (value.contains(RegExp(r'[a-z]'))) {
                      setState(() {
                        _isLowercaseOk = true;
                      });
                    } else {
                      setState(() {
                        _isLowercaseOk = false;
                      });
                    }

                    if (value
                        .contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                      setState(() {
                        _isSpecialCharOk = true;
                      });
                    } else {
                      setState(() {
                        _isSpecialCharOk = false;
                      });
                    }
                  },
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.toString().length < 8) {
                      return "Password must be at least 8 characters!";
                    }
                    if (!_isNumberOk ||
                        !_isCapitalOk ||
                        !_isLowercaseOk ||
                        !_isSpecialCharOk) {
                      return 'Weak password. See hint below';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextBody1(text: "Confirm Password"),
                const SizedBox(
                  height: 4.0,
                ),
                PasswordField(
                  onChanged: (val) {},
                  hint: "",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please re-type password';
                    }
                    if (_newPasswordController.text != value) {
                      return "Password does not match!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                RichText(
                  text: const TextSpan(
                    text: "Use at least one ",
                    style: TextStyle(
                      color: Color(0xFF3B3B3B),
                    ),
                    children: [
                      TextSpan(
                        text: "uppercase",
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ", one ",
                        style: TextStyle(
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                      TextSpan(
                        text: "lowercase",
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ", one ",
                        style: TextStyle(
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                      TextSpan(
                        text: "numeric digit",
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: " and one ",
                        style: TextStyle(
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                      TextSpan(
                        text: "special character",
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ". ",
                        style: TextStyle(
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 56.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    buttonText: "Save",
                    fontSize: 15,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _changePass();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
