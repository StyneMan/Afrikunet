// ignore_for_file: unused_field

import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
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
  final PreferenceManager manager;
  const LoginForm({
    Key? key,
    required this.manager,
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

  // ignore: unused_field
  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    Map _payload = {
      "email_address": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      final _prefs = await SharedPreferences.getInstance();
      final _response = await APIService().login(_payload);
      _controller.setLoading(false);
      debugPrint("LOGIN RESPONSE :: ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        // Successful
        Map<String, dynamic> _mapper = jsonDecode(_response.body);
        //Save user data and preferences
        String userData = jsonEncode(_mapper['user']);
        _prefs.setString("userData", userData);
        _controller.setUserData(_mapper['user']);
        widget.manager.setUserData(userData);

        if (_mapper['user']['is_email_verified'] == false) {
          Get.to(
            VerifyOTP(
              email: _emailController.text,
              caller: "signup",
              manager: widget.manager,
            ),
            transition: Transition.cupertino,
          );
        } else {
          // Save accesstoken
          _prefs.setString("accessToken", _mapper['accessToken']);

          // Send user's id to server here
          socket.emit('identity', _mapper['user']['email_address']);

          Constants.toast("${_mapper['message']}");
          _prefs.setBool("loggedIn", true);
          _controller.onInit();
          Get.to(
            Dashboard(manager: widget.manager),
            transition: Transition.cupertino,
          );
        }
      } else {
        Map<String, dynamic> _errorMapper = jsonDecode(_response.body);
        Constants.toast("${_errorMapper['message']}");
      }
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                onChanged: (val) {},
                placeholder: "Email",
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
                height: 10.0,
              ),
              PasswordField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type password';
                  }
                  if (value.toString().length < 8) {
                    return "Password must be at least 8 characters!";
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: PrimaryButton(
                  buttonText: "Login",
                  foreColor: Colors.white,
                  fontSize: 16,
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
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
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(Register(), transition: Transition.cupertino);
                    },
                    child: TextSmall(
                      text: "Create Account ",
                      fontWeight: FontWeight.w500,
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
