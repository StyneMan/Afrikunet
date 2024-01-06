import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

class TwoFactorAuthScreen extends StatelessWidget {
  const TwoFactorAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 24.0,
                        ),
                        Image.asset("assets/images/security_2fa.png"),
                        const SizedBox(
                          height: 18.0,
                        ),
                        TextHeading(
                          text: "Welcome to the 2FA Authentication",
                          align: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextBody1(
                          text:
                              "The primary purpose of 2FA is to add an extra layer of security beyond just a password.",
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: PrimaryButton(
                    buttonText: "Get Started",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
