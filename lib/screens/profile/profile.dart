import 'dart:io';

import 'package:afrikunet/components/picker/img_picker.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/security/security.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isImagePicked = false;

  var _croppedFile;

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });
    print("VALUIE::: :: $file");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Constants.secondaryColor,
        automaticallyImplyLeading: false,
        title: TextHeading(
          text: "Profile",
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Constants.secondaryColor,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: const SizedBox(
                height: 8.0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Container(
                              color: Constants.primaryColor.withOpacity(0.5),
                              child: _isImagePicked
                                  ? Image.file(
                                      File(_croppedFile),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SvgPicture.asset(
                                        "assets/images/account.svg",
                                        fit: BoxFit.cover,
                                        color: Constants.primaryColor,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.36,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.36,
                                      ),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.36,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.36,
                                    )
                                  : Image.asset(
                                      "assets/images/developer.jpg",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SvgPicture.asset(
                                        "assets/images/afrikunet_logo.svg",
                                        fit: BoxFit.cover,
                                        color: Constants.primaryColor,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                      ),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.40,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: -10,
                            child: TextButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  Container(
                                    height: 150,
                                    color: Colors.white,
                                    child: ImgPicker(
                                      onCropped: _onImageSelected,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36.0),
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Constants.primaryColor,
                                child: SvgPicture.asset(
                                  "assets/images/edit_pen.svg",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: TextLarge(
                        text: "Stanley Brown",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      children: [
                        Chip(
                          backgroundColor:
                              Constants.primaryColor.withOpacity(0.3),
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextBody1(
                              text: 'stanleynyekpeye@gmail.com',
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              const AppSecurity(),
                              transition: Transition.cupertino,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 18.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextMedium(
                                        text: "Security",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextBody2(
                                        text: "2FA, App lock, Pin & Biometrics",
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
                          height: 2.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextButton(
                          onPressed: () {
                            // Get.to(
                            //   const WalletScreen(),
                            //   transition: Transition.cupertino,
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/people.svg",
                                    color: Colors.black54,
                                    width: 22,
                                    height: 18,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextMedium(
                                        text: "About Us",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextBody2(
                                        text:
                                            "FAQs, Privacy Policy, Contact us",
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
                          height: 2.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextButton(
                          onPressed: () {
                            // Get.to(
                            //   ContactSupport(),
                            //   transition: Transition.cupertino,
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.settings,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextMedium(
                                        text: "Settings",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextBody2(
                                        text: "",
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
                          height: 2.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextButton(
                          onPressed: () {
                            // _logout();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.square_arrow_left,
                                    color: Colors.red,
                                    size: 21,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  TextMedium(
                                    text: "Logout",
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 21,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}