import 'dart:convert';

import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/forgotpassword/passwordform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';

import '../../../forms/signup/signupform.dart';
import '../../../helper/state/state_manager.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _controller = Get.find<StateController>();

  PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://i.imgur.com/RwCXUQu.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            children: [
              TextLarge(
                text: "Forgot password?",
                align: TextAlign.center,
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextBody1(
                text:
                    "Enter email you used in signing up and we will help you reset your password",
                align: TextAlign.center,
                color: Colors.black87,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              PasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
