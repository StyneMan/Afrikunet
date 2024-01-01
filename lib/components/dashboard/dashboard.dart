import 'dart:io';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/home/home.dart';
import 'package:afrikunet/screens/profile/profile.dart';
import 'package:afrikunet/screens/settings/settings.dart';
import 'package:afrikunet/screens/vouchers/my_vouchers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:afrikunet/screens/network/no_internet.dart';

class Dashboard extends StatefulWidget {
  final bool showProfile;
  Dashboard({Key? key, this.showProfile = false}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoggedIn = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    _controller.selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 4);
        pre_backpress = DateTime.now();
        if (cantExit) {
          Fluttertoast.showToast(
            msg: "Press again to exit",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return false; // false will do nothing when back press
        } else {
          // _controller.triggerAppExit(true);
          if (Platform.isAndroid) {
            exit(0);
          } else if (Platform.isIOS) {}
          return true;
        }
      },
      child: Obx(
        () => LoadingOverlayPro(
          isLoading: _controller.isLoading.value,
          progressIndicator: const CircularProgressIndicator.adaptive(),
          backgroundColor: Colors.black54,
          child: !_controller.hasInternetAccess.value
              ? const NoInternet()
              : Scaffold(
                  key: _scaffoldKey,
                  body: _buildScreens()[_controller.selectedIndex.value],
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _controller.selectedIndex.value,
                    onTap: _onItemTapped,
                    showUnselectedLabels: true,
                    selectedItemColor: Constants.primaryColor,
                    unselectedItemColor: Colors.grey,
                    unselectedLabelStyle: const TextStyle(color: Colors.grey),
                    type: BottomNavigationBarType.fixed,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/home_icon.svg",
                          color: Colors.grey,
                        ),
                        label: 'Home',
                        activeIcon: SvgPicture.asset(
                          "assets/images/home_icon.svg",
                          color: Constants.primaryColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/voucher_icon.svg",
                          color: Colors.grey,
                        ),
                        label: 'My Vouchers',
                        activeIcon: SvgPicture.asset(
                          "assets/images/voucher_icon.svg",
                          color: Constants.primaryColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/profile_icon.svg",
                          color: Colors.grey,
                        ),
                        label: 'Profile',
                        activeIcon: SvgPicture.asset(
                          "assets/images/profile_icon.svg",
                          color: Constants.primaryColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/settings_icon.svg",
                          color: Colors.grey,
                        ),
                        label: 'Settings',
                        activeIcon: SvgPicture.asset(
                          "assets/images/settings_icon.svg",
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      const MyVouchersPage(),
      const ProfilePage(),
      const SettingsPage(),
    ];
  }
}
