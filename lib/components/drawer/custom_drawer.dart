import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/screens/airtime/airtime.dart';
import 'package:afrikunet/screens/bank/add_bank.dart';
import 'package:afrikunet/screens/bills/billpay.dart';
import 'package:afrikunet/screens/profile/profile.dart';
import 'package:afrikunet/screens/vouchers/my_vouchers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/model/drawer/drawermodel.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<DrawerModel> drawerList = [];

  final _controller = Get.find<StateController>();

  _initAuth() {
    setState(() {
      drawerList = [
        DrawerModel(
          icon: 'assets/images/profile_icon.svg',
          title: 'Profile',
          isAction: false,
          widget: const ProfilePage(),
        ),
        DrawerModel(
          icon: 'assets/images/bill_pay.svg',
          title: 'Bill Pay',
          isAction: false,
          widget: const BillPay(),
        ),
        DrawerModel(
          icon: 'assets/images/airtime.svg',
          title: 'Airtime',
          isAction: false,
          widget: const Airtime(),
        ),
        DrawerModel(
          icon: 'assets/images/voucher_icon.svg',
          title: 'My Vouchers',
          isAction: false,
          widget: const MyVouchersPage(),
        ),
        DrawerModel(
          icon: 'assets/images/add_bank.svg',
          title: 'Add Bank',
          isAction: false,
          widget: AddBank(),
        ),
        DrawerModel(
          icon: 'assets/images/share_ios.svg',
          title: 'Share Experience',
          isAction: false,
          widget: const SizedBox(),
        ),
        DrawerModel(
          icon: 'assets/images/feedback.svg',
          title: 'Feedback',
          isAction: false,
          widget: const SizedBox(),
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  _logout() async {}

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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.275),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 42,
                left: 18,
                right: 18,
                bottom: 16,
              ),
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    foregroundImage: AssetImage("assets/images/developer.jpg"),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSmall(
                        text: "Stanley Brown",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      const Text(
                        "stanleynyekpeye@gmail.com",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ListTile(
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      drawerList[i].icon,
                                      width: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    const SizedBox(
                                      width: 21.0,
                                    ),
                                    TextSmall(
                                      text: drawerList[i].title,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  if (i == 0) {
                                    Get.back();
                                    _controller.selectedIndex.value = 2;
                                  } else if (i == 1) {
                                    Get.back();
                                    Get.to(
                                      drawerList[i].widget,
                                      transition: Transition.cupertino,
                                    );
                                  } else if (i == 2) {
                                    Get.back();
                                    Get.to(
                                      drawerList[i].widget,
                                      transition: Transition.cupertino,
                                    );
                                  } else if (i == 3) {
                                    Get.back();
                                    _controller.selectedIndex.value = 1;
                                  } else if (i == 4) {
                                    Get.back();
                                    Get.to(
                                      drawerList[i].widget,
                                      transition: Transition.cupertino,
                                    );
                                  }

                                  // else {
                                  //   if (drawerList[i].isAction) {
                                  //     Navigator.of(context).pop();
                                  //     _launchInBrowser("${drawerList[i].url}");
                                  //   } else {
                                  //     Navigator.of(context).pop();
                                  //     Navigator.of(context).push(
                                  //       PageTransition(
                                  //         type: PageTransitionType.size,
                                  //         alignment: Alignment.bottomCenter,
                                  //         child: drawerList[i].widget!,
                                  //       ),
                                  //     );
                                  //   }
                                  // }
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: drawerList.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 21.0,
                          vertical: 6.0,
                        ),
                        child: DottedDivider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 0.0,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.settings,
                                size: 23,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(
                                width: 21.0,
                              ),
                              TextSmall(
                                text: "Account Settings",
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.back();
                            _controller.selectedIndex.value = 3;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 0.0,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.square_arrow_left,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(
                                width: 21.0,
                              ),
                              TextSmall(
                                text: "Logout",
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                          onTap: () async {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
