import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/security/2fa_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'change_password.dart';

class AppSecurity extends StatefulWidget {
  const AppSecurity({Key? key}) : super(key: key);

  @override
  State<AppSecurity> createState() => _AppSecurityState();
}

class _AppSecurityState extends State<AppSecurity> {
  bool _isAppLock = false, _isTouchID = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            TextHeading(
              text: "Security",
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              shadowColor: const Color(0xFFD0D0D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: const Color(0xFFF2F2F2),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          const TwoFactorAuthScreen(),
                          transition: Transition.cupertino,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child:
                                    SvgPicture.asset("assets/images/twofa.svg"),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextSmall(text: "Two Factor Authentication"),
                                  TextBody1(
                                    text: "Not enabled",
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.lock_outline_rounded),
                              ),
                              const SizedBox(width: 8.0),
                              TextSmall(text: "App Lock"),
                            ],
                          ),
                          CupertinoSwitch(
                            value: _isAppLock,
                            onChanged: (value) {
                              setState(() => _isAppLock = !_isAppLock);
                            },
                            activeColor: Constants.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset(
                                    "assets/images/open_touch_id.svg"),
                              ),
                              const SizedBox(width: 8.0),
                              TextSmall(text: "Open app with touch ID"),
                            ],
                          ),
                          CupertinoSwitch(
                            value: _isTouchID,
                            onChanged: (value) {
                              setState(() => _isTouchID = !_isTouchID);
                            },
                            activeColor: Constants.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          const ChangePassword(),
                          transition: Transition.cupertino,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset(
                                    "assets/images/biometric.svg"),
                              ),
                              const SizedBox(width: 8.0),
                              TextSmall(text: "Change Password"),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
