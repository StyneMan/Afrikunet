import 'dart:convert';

import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/login/loginform.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        scopes: ['email'],
      ).signIn();

      Map _payload = {
        "first_name": googleUser?.displayName?.split(' ')[0].toLowerCase(),
        "last_name": ((googleUser?.displayName ?? "").contains(' ')
                ? googleUser?.displayName?.split(' ')[1]
                : " ")
            ?.toLowerCase(),
        "email_address": googleUser?.email,
        "photo": '${googleUser?.photoUrl}',
      };
      _controller.setLoading(true);

      print("PAYLOAD ::: ${_payload}");

      final _resp = await APIService().googleAuth(_payload);

      debugPrint("Google Server Respone >> ${_resp.body}");
      _controller.setLoading(false);
      if (_resp.statusCode >= 200 && _resp.statusCode <= 299) {
        Map<String, dynamic> _mapper = jsonDecode(_resp.body);
        final _prefs = await SharedPreferences.getInstance();
        //Save user data and preferences
        String userData = jsonEncode(_mapper['user']);
        _prefs.setString("userData", userData);
        _controller.setUserData(_mapper['user']);
        // _manager?.setUserData(userData);
        // _manager?.saveAccessToken(_mapper['accessToken']);
        _prefs.setString("accessToken", _mapper['accessToken']);
        _controller.onInit();

        _prefs.setBool("loggedIn", true);
        Get.to(
          Dashboard(manager: _manager!),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> _errMap = jsonDecode(_resp.body);
        Constants.toast("${_errMap['message']}");
      }
    } catch (e) {
      _controller.setLoading(false);
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
              decoration: BoxDecoration(
                image: _controller.currentThemeMode.value == "dark"
                    ? null
                    : const DecorationImage(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.cover,
                      ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: [
                  TextHeading(
                    text: "Login",
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  GoogleButton(
                    buttonText: "Continue with Google",
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    foreColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 2.0),
                    child: HorzTextDivider(text: 'or'),
                  ),
                  LoginForm(manager: _manager!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
