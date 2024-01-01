import 'dart:convert';

import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/login/loginform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';

import '../../../helper/state/state_manager.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controller = Get.find<StateController>();

  PreferenceManager? _manager;

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
  }

  _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // debugPrint("GOOGLE USER RESP >> ${googleUser}");

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;
      debugPrint("Google ID TOKEN >> ${googleAuth?.idToken}");
      // final resp = await APIService().googleAuth("${googleAuth?.idToken}");

      // debugPrint("Google Server Respone >> ${resp.body}");
    } catch (e) {
      debugPrint("ERR >> $e");
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  TextLarge(
                    text: "Login",
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  GoogleButton(
                    buttonText: "Continue with Google",
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    foreColor: Colors.black87,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 2.0),
                    child: HorzTextDivider(text: 'or'),
                  ),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
