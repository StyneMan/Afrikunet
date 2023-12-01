import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/screens/auth/register/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:afrikunet/components/button/roundedbutton.dart';
import 'package:afrikunet/components/inputfield/passwordfield.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/helper/socket/socket_manager.dart';

import '../../components/text_components.dart';
import '../../helper/constants/constants.dart';
import '../../helper/preference/preference_manager.dart';
import '../../helper/state/state_manager.dart';
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

  _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // _controller.setLoading(true);
    // Map _payload = {
    //   "email": _emailController.text,
    //   "password": _passwordController.text,
    // };
    try {} catch (e) {
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
                hintText: "Email",
                onChanged: (val) {},
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or phone';
                  }
                  if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
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
                  return null;
                },
                controller: _passwordController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 2.0,
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
                    text: "New Here? ",
                    color: Colors.black,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(Register(), transition: Transition.cupertino);
                    },
                    child: TextSmall(
                      text: " Create Account ",
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
