import 'package:afrikunet/components/buttons/google.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/login/loginform.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:afrikunet/components/dividers/horz_text_divider.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';

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

      debugPrint("GOOGLE USER RESP >> ${googleUser}");
      debugPrint("GOOGLE USER RESP >> ${googleUser?.displayName}");
      debugPrint("GOOGLE USER RESP >> ${googleUser?.email}");

      if (googleUser != null) {
        final auth = await googleUser.authentication;
        String? idToken = auth.idToken;
        if (idToken != null) {
          // call the server with ID token
        }
        // final _redirectResponse = await APIService().googleAuthRedirect(
        //   authHeaders: authHeaders,
        // );

        // debugPrint("REDIRECT RESPONSE ::: ${_redirectResponse.body}");
        // final response = await http.get(
        //   Uri.parse('http://your-nestjs-backend/auth/google/callback'),
        //   headers: authHeaders,
        // );
      } else {
        // Operation failed right here
      }

      // Obtain the auth details from the request
      // final googleAuth = await googleUser?.authentication;
      // debugPrint("Google ID TOKEN >> ${googleAuth?.idToken}");
      // debugPrint("Google ID TOKEN >> ${googleAuth?.}");

      // Map _payload = {
      //   "first_name": googleUser?.displayName?.split(' ')[0].toLowerCase(),
      //   "last_name": googleUser?.displayName?.split(' ')[1].toLowerCase(),
      //   "email_address": googleUser?.email,
      //   "photo": '${googleUser?.photoUrl}',
      // };

      // final resp = await APIService().googleAuth(_payload);

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
