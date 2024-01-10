import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:afrikunet/components/inputfield/passwordfield.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/helper/socket/socket_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/constants/constants.dart';
import '../../screens/auth/forgotPass/forgotPass.dart';

class LoginForm extends StatefulWidget {
  // final PreferenceManager manager;
  LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();

  final socket = SocketManager().socket;

  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    // Map _payload = {
    //   "email": _emailController.text,
    //   "password": _passwordController.text,
    // };
    try {
      final _prefs = await SharedPreferences.getInstance();

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        _prefs.setBool("loggedIn", true);
        Get.to(
          Dashboard(),
          transition: Transition.cupertino,
        );
      });
    } catch (e) {
      _controller.setLoading(false);
      // print(e.message);
      Constants.toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              TextBody1(text: "Email"),
              const SizedBox(
                height: 4.0,
              ),
              CustomTextField(
                onChanged: (val) {},
                placeholder: "Enter email address",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextBody1(text: "Password"),
              const SizedBox(
                height: 4.0,
              ),
              PasswordField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type password';
                  }
                  if (value.toString().length < 8) {
                    return "Password must be at least 8 characters!";
                  }
                  if (!_isNumberOk ||
                      !_isCapitalOk ||
                      !_isLowercaseOk ||
                      !_isSpecialCharOk) {
                    return 'Password is too weak!';
                  }
                  return null;
                },
                controller: _passwordController,
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
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(
                        const ForgotPassword(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: TextBody1(
                      text: "Forgot password?",
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  buttonText: "Login",
                  foreColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextSmall(
                    text: "New Here?",
                    color: Colors.black,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(Register(), transition: Transition.cupertino);
                    },
                    child: TextSmall(
                      text: "Create Account ",
                      fontWeight: FontWeight.w600,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 21.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
