import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordForm extends StatefulWidget {
  final PreferenceManager manager;
  const PasswordForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  _forgotPass() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);
    try {
      Map _payload = {
        "email_address": _emailController.text,
      };

      final _response = await APIService().forgotPass(_payload);
      debugPrint("LOGIN RESPONSE :: ${_response.body}");
      _controller.setLoading(false);

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Get.to(
          VerifyOTP(
            email: _emailController.text,
            caller: "password",
            manager: widget.manager,
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> _errorMapper = jsonDecode(_response.body);
        Constants.toast("${_errorMapper['message']}");
      }
    } catch (e) {
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
          CustomTextField(
            hintText: "",
            placeholder: "Enter email address",
            onChanged: (val) {},
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
            height: 21.0,
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              foreColor: Colors.white,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _forgotPass();
                }
              },
              buttonText: "Send Reset Link",
            ),
          )
        ],
      ),
    );
  }
}
