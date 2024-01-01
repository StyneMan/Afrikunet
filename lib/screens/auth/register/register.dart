import 'dart:convert';

import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';

import '../../../forms/signup/signupform.dart';
import '../../../helper/state/state_manager.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      debugPrint("Google ID TOKEN >> ${googleAuth}");
      // final resp = await APIService().googleAuth("${googleAuth?.idToken}");

      // debugPrint("Google Server Respone >> ${resp.body}");

      // Map<String, dynamic> map = jsonDecode(resp.body);
      // _manager!.saveAccessToken(map['token']);
      // _controller.firstname.value =
      //     "${map['data']['bio']['fullname']}".split(" ")[0].capitalize!;
      // _controller.lastname.value =
      //     "${map['data']['bio']['fullname']}".split(" ")[1].capitalize!;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  TextLarge(
                    text: "Create Account",
                    align: TextAlign.center,
                  ),
                  TextBody1(
                    text: "Exchange Made Easy",
                    align: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  GoogleButton(
                    buttonText: "Sign Up with Google",
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    foreColor: Colors.black87,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const HorzTextDivider(text: 'or sign up with email'),
                  const SizedBox(
                    height: 4.0,
                  ),
                  SignupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
