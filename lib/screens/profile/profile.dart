import 'dart:io';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/picker/img_picker.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/login/login.dart';
import 'package:afrikunet/screens/security/security.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final PreferenceManager manager;
  const ProfilePage({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isImagePicked = false;
  final _controller = Get.find<StateController>();

  var _croppedFile;

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });
    print("VALUIE::: :: $file");

    // Update after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _uploadPhoto();
    });
  }

  _uploadPhoto() async {
    try {
      //Now upload to Firebase Storage first
      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef
          .child("photos")
          .child("${widget.manager.getUser()['email_address']}");
      final _resp = await fileRef.putFile(File(_controller.croppedPic.value));
      final url = await _resp.ref.getDownloadURL();

      // Now update the user's profile here
      final _response = await APIService().updateProfile(
        accessToken: "",
        body: {"photo": url},
        id: int.parse("${_controller.userData.value['id'] ?? 0}"),
      );

      _controller.onInit();

      debugPrint("UPDATE PROFILE RESPONXE :: ${_response.body}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("HJ ${widget.manager.getUser()['photo']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                                  : CachedNetworkImage(
                                      imageUrl:
                                          "${_controller.userData.value['photo'] ?? widget.manager.getUser()['photo']}",
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        "assets/images/personal_icon.svg",
                                        fit: BoxFit.cover,
                                        color: Constants.primaryColor,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                      ),
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
                        text:
                            "${widget.manager.getUser()['first_name']} ${widget.manager.getUser()['last_name']}"
                                .capitalize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
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
                              text:
                                  '${widget.manager.getUser()['email_address']}',
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
                              AppSecurity(
                                manager: widget.manager,
                              ),
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
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextBody2(
                                        text: "2FA, App lock, Pin & Biometrics",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 21,
                                color: Theme.of(context).colorScheme.tertiary,
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
                            _launchInBrowser("https://afrikunet.com");
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextBody2(
                                        text:
                                            "FAQs, Privacy Policy, Contact us",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 21,
                                color: Theme.of(context).colorScheme.tertiary,
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
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.delete,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 23,
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
                                        text: "Delete Account",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 21,
                                color: Theme.of(context).colorScheme.tertiary,
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
                            _showDialog();
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

  _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: TextMedium(
                  text: "Confirm Logout",
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 18.0,
                    ),
                    TextSmall(
                      text:
                          "Are you sure you want to logout? Click button below to proceed.",
                      align: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            buttonText: "Cancel",
                            foreColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            buttonText: "Continue",
                            onPressed: () {
                              _logout();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _logout() async {
    _controller.setLoading(false);
    Get.back();
    try {
      _controller.setLoading(true);
      final _prefs = await SharedPreferences.getInstance();

      Future.delayed(const Duration(seconds: 3), () {
        _controller.setLoading(false);
        widget.manager.clearProfile();
        _prefs.clear();
        Get.offAll(const Login());
      });
    } catch (e) {
      _controller.setLoading(false);
    }
  }
}
