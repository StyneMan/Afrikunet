import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/screens/airtime/airtime.dart';
import 'package:afrikunet/screens/bank/add_bank.dart';
import 'package:afrikunet/screens/bills/billpay.dart';
import 'package:afrikunet/screens/getstarted/getstarted.dart';
import 'package:afrikunet/screens/profile/profile.dart';
import 'package:afrikunet/screens/vouchers/get_paid.dart';
import 'package:afrikunet/screens/vouchers/my_vouchers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/model/drawer/drawermodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  final PreferenceManager manager;
  const CustomDrawer({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<DrawerModel> drawerList = [];

  final _controller = Get.find<StateController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  _initAuth() {
    setState(() {
      drawerList = [
        DrawerModel(
          icon: 'assets/images/profile_icon.svg',
          title: 'Profile',
          isAction: false,
          widget: ProfilePage(manager: widget.manager),
        ),
        DrawerModel(
          icon: 'assets/images/bill_pay.svg',
          title: 'Bill Pay',
          isAction: false,
          widget: BillPay(manager: widget.manager),
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
          widget: MyVouchersPage(manager: widget.manager),
        ),
        DrawerModel(
          icon: 'assets/images/add_bank.svg',
          title: 'Add Bank',
          isAction: false,
          widget: AddBank(
            manager: widget.manager,
          ),
        ),
        DrawerModel(
          icon: 'assets/images/share_ios.svg',
          title: 'Get Paid',
          isAction: false,
          widget: GetPaid(
            manager: widget.manager,
          ),
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

  _logout() async {
    try {
      _controller.setLoading(true);
      await _googleSignIn.signOut();
      Future.delayed(const Duration(seconds: 2), () {
        _controller.setLoading(false);
        widget.manager.clearProfile();

        Get.offAll(GetStarted());
      });
    } catch (e) {
      _controller.setLoading(false);
      print("Log out Error ===> $e");
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
  Widget build(BuildContext context) {
    print("JKS KJKS KJS ${widget.manager.getUser()['photo']}");
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
                top: 45,
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
                  ClipOval(
                    child: Image.network(
                      "${widget.manager.getUser()['photo']}",
                      errorBuilder: (context, url, error) => SvgPicture.asset(
                        "assets/images/personal_icon.svg",
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                      ),
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(
                          text:
                              "${widget.manager.getUser()['first_name']} ${widget.manager.getUser()['last_name']}"
                                  .capitalize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        Text(
                          "${widget.manager.getUser()['email_address']}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                  vertical: 0.0,
                                ),
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
                                    _controller.selectedIndex.value = 3;
                                  } else if (i == 1 ||
                                      i == 2 ||
                                      i == 4 ||
                                      i == 5) {
                                    Get.back();
                                    Get.to(
                                      drawerList[i].widget,
                                      transition: Transition.cupertino,
                                    );
                                  } else if (i == 3) {
                                    Get.back();
                                    _controller.selectedIndex.value = 1;
                                  }
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 21.0,
                          vertical: 0.0,
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
                          onTap: () async {
                            Get.back();
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) => InfoDialog(
                                body: SingleChildScrollView(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 40.0),
                                        Icon(
                                          CupertinoIcons.info_circle,
                                          size: 48,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        const SizedBox(height: 10.0),
                                        TextMedium(
                                          text:
                                              "Are you sure you want to logout?",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        const SizedBox(
                                          height: 21,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 21.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SecondaryButton(
                                                  buttonText: "Cancel",
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: PrimaryButton(
                                                  buttonText: "Logout",
                                                  onPressed: () {
                                                    Get.back();
                                                    _logout();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
