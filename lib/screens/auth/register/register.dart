import 'dart:convert';

import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:afrikunet/components/button/roundedbutton.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../components/text_components.dart';
import '../../../forms/signup/signupform.dart';
import '../../../helper/constants/constants.dart';
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
      // debugPrint("Google ID TOKEN >> ${googleAuth?.idToken}");
      final resp = await APIService().googleAuth("${googleAuth?.idToken}");

      debugPrint("Google Server Respone >> ${resp.body}");

      Map<String, dynamic> map = jsonDecode(resp.body);
      _manager!.saveAccessToken(map['token']);
      _controller.firstname.value =
          "${map['data']['bio']['fullname']}".split(" ")[0].capitalize!;
      _controller.lastname.value =
          "${map['data']['bio']['fullname']}".split(" ")[1].capitalize!;

      if (map['message'].contains("Account created")) {
        //New account so now select user type recruiter or freelancer
        // Navigator.of(context).pushReplacement(
        //   PageTransition(
        //     type: PageTransitionType.size,
        //     alignment: Alignment.bottomCenter,
        //     child: AccountType(
        //       isSocial: true,
        //       email: map['data']['email'],
        //       name: map['data']['bio']['fullname'],
        //     ),
        //   ),
        // );
      } else {
        if (!map['data']["hasProfile"]) {
          // Navigator.of(context).pushReplacement(
          //   PageTransition(
          //     type: PageTransitionType.size,
          //     alignment: Alignment.bottomCenter,
          //     child: map['data']["accountType"].toString().toLowerCase() ==
          //             "professional"
          //         ? SetupProfile(
          //             manager: _manager!,
          //             isSocial: true,
          //             email: map['data']['email'],
          //             name: map['data']['bio']['fullname'],
          //           )
          //         : SetupProfileEmployer(
          //             manager: _manager!,
          //             isSocial: true,
          //             email: map['data']['email'],
          //             name: map['data']['bio']['fullname'],
          //           ),
          //   ),
          // );
        } else {
          String userData = jsonEncode(map['data']);
          _manager!.setUserData(userData);
          _manager!.setIsLoggedIn(true);
          _controller.setUserData(map['data']);

          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.size,
              alignment: Alignment.bottomCenter,
              child: Dashboard(
                manager: _manager!,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("ERR >> $e");
    }
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
                onPressed: () {},
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
    );
  }
}
