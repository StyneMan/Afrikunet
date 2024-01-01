import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/passwordfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordForm extends StatefulWidget {
  ChangePasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _controller = Get.find<StateController>();

  final _formKey = GlobalKey<FormState>();

  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  _resetPass() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    Future.delayed(const Duration(seconds: 3), () {
      _controller.setLoading(false);
      Get.to(
        const Login(),
        transition: Transition.cupertino,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

              if (value.contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                setState(() {
                  _isSpecialCharOk = true;
                });
              } else {
                setState(() {
                  _isSpecialCharOk = false;
                });
              }
            },
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
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
            height: 24.0,
          ),
          TextBody1(text: "Verify Password"),
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
              if (_passwordController.text != value) {
                return "Password does not match!";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Confirm",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _resetPass();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
