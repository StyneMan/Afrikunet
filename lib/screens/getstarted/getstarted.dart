import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/login/login.dart';
import 'package:afrikunet/screens/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStarted extends StatelessWidget {
  GetStarted({Key? key}) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          image: _controller.currentThemeMode.value == "dark"
              ? null
              : const DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/get_started.png'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextLarge(
                    text: "Let's Get Started",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  TextBody1(
                    text: "Buy gift, share and connect",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 16),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                    buttonText: "Sign Up",
                    onPressed: () {
                      Get.to(
                        const Register(),
                        transition: Transition.cupertino,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SecondaryButton(
                    buttonText: "Log In",
                    onPressed: () {
                      Get.to(
                        const Login(),
                        transition: Transition.cupertino,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
