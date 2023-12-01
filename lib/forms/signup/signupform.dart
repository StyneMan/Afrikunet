import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/screens/auth/login/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:afrikunet/components/inputfield/passwordfield.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';

import '../../helper/constants/constants.dart';
import '../../helper/state/state_manager.dart';

typedef InitCallback(bool params);

class SignupForm extends StatefulWidget {
  // final PreferenceManager manager;
  SignupForm({
    Key? key,
    // required this.manager,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  String _countryCode = "+234";
  bool _obscureText = true, _loading = false, _isChecked = false;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  String _number = '';

  _register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // _controller.setLoading(true);

    Map _payload = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      //   debugPrint("DFDF  ${_payload}");
      //   final resp = await APIService().signup(_payload);
      //   debugPrint("DFDF  ${resp.body}");
      //   // Constants.toast(resp.body);
      //   _controller.setLoading(false);

      //   if (resp.statusCode == 200) {
      //     Map<String, dynamic> map = jsonDecode(resp.body);
      //     Constants.toast(map['message']);
      //     //Route to verification
      //     Navigator.of(context).pushReplacement(
      //       PageTransition(
      //         type: PageTransitionType.size,
      //         alignment: Alignment.bottomCenter,
      //         child: VerifyOTP(
      //           caller: "Signup",
      //           manager: widget.manager,
      //           email: _emailController.text,
      //         ),
      //       ),
      //     );
      //   } else {
      //     Map<String, dynamic> map = jsonDecode(resp.body);
      //     Constants.toast("${map['message']}");
      //   }
    } catch (e) {
      debugPrint("ERROR: $e");
      _controller.setLoading(false);
    }
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
            text: "Name",
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            hintText: "Enter your fullname",
            onChanged: (val) {},
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone';
              }
              return null;
            },
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextBody1(text: "Phone Number"),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            hintText: "Phone ",
            onChanged: (val) {},
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }

              return null;
            },
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextBody1(text: "Email"),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            hintText: "Enter email",
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
            height: 32.0,
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: 'Create',
              foreColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (e) {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By continuing you accept our standard ",
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: "terms and conditions",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constants.accentColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Constants.toast("Not yet implemented!"),
                        ),
                        TextSpan(text: " and our "),
                        TextSpan(
                          text: "privacy policy",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constants.accentColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Constants.toast("Not yet implemented!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextSmall(
                text: "Already have an account? ",
                color: Colors.black,
              ),
              TextButton(
                onPressed: () {
                  Get.to(Login(), transition: Transition.cupertino);
                },
                child: TextSmall(
                  text: " Log In ",
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
