import 'dart:convert';
import 'dart:io';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/custom_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/home/home.dart';
import 'package:afrikunet/screens/profile/edit_profile.dart';
import 'package:afrikunet/screens/profile/profile.dart';
import 'package:afrikunet/screens/settings/settings.dart';
import 'package:afrikunet/screens/vouchers/my_vouchers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:afrikunet/screens/network/no_internet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final bool showProfile;
  final PreferenceManager manager;
  const Dashboard({
    Key? key,
    this.showProfile = false,
    required this.manager,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.find<StateController>();

  _init() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";
      final _user = _prefs.getString("user") ?? "";
      Map<String, dynamic> _userMap = jsonDecode(_user);

      if (_userMap['is_profile_set'] == false) {
        // Show Dialog here
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.98,
            child: CustomDialog(
              ripple: SvgPicture.asset(
                "assets/images/check_effect.svg",
                width: (Constants.avatarRadius + 2),
                height: (Constants.avatarRadius + 2),
              ),
              avtrBg: Colors.transparent,
              avtrChild: const Icon(
                CupertinoIcons.info_circle,
                size: 86,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 36.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextMedium(
                      text: "Profile Setup Required!",
                      fontWeight: FontWeight.w600,
                      align: TextAlign.center,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextSmall(
                      text:
                          "You must setup your profile to continue using this app",
                      fontWeight: FontWeight.w400,
                      align: TextAlign.center,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.36,
                      child: PrimaryButton(
                        buttonText: "Complete Profile",
                        foreColor: Colors.white,
                        bgColor: Theme.of(context).colorScheme.primaryContainer,
                        onPressed: () {
                          Get.to(
                            EditProfile(manager: widget.manager),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      final response = await APIService().getVTUs();
      debugPrint("PRODUCT RESP:: ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        // ProductResponse body = ProductResponse.fromJson(map);
        _controller.setVtus(map['data']);

        map['data']?.forEach((elem) => {
              if (elem['name'].toString().toLowerCase() == "airtime")
                {_controller.airtimeData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "data")
                {_controller.internetData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "electricity")
                {_controller.electricityData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "cable_tv")
                {_controller.cableData.value = elem}
            });
      }

      final _bankAccountsResponse = await APIService().fetchUserBankAccounts(
        accessToken: _token,
        userId: _userMap['email_address'],
      );

      if (_bankAccountsResponse.statusCode >= 200 &&
          _bankAccountsResponse.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_bankAccountsResponse.body);
        print("MY BANK ACCOUNTS  ::: ${data['data']}");
        _controller.userBankAccounts.value = data['data'];
        data['data']?.forEach((elem) {
          if (elem['is_default']) {
            // This is the default bank here
            _controller.userDefaultBank.value = elem;
          }
        });
      }

      final _topupResponse = await APIService().getVTUCountries(type: '');
      debugPrint("INTERNATIONAL VTU PEOPLE ::: ${_topupResponse.body}");
      if (_topupResponse.statusCode >= 200 &&
          _topupResponse.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_topupResponse.body);
        _controller.internationVTUData.value = map['data'];
        _controller.filteredVTUCountries.value = map['topup'];
        _controller.filteredVTUDataCountries.value = map['data'];
        _controller.internationVTUTopup.value = map['topup'];
      }

      final _voucherResponse = await APIService().getUserVouchers(
        accessToken: _token,
        page: 1,
        limit: 20,
      );

      if (_voucherResponse.statusCode >= 200 &&
          _voucherResponse.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_voucherResponse.body);
        print("MY VOUCHERS  ::: ${data['vouchers']}");
        _controller.userVouchers.value = data['vouchers'];
      }

      final _countriesResponse = await APIService().getBankCountries();
      debugPrint("SUPPORTED COUNTRIES RESP:: ${_countriesResponse.body}");
      if (_countriesResponse.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(_countriesResponse.body);
        _controller.bankCountries.value = map['data'];
        _controller.filteredCountries.value = map['data'];
      }

      final _unusedVoucherResponse = await APIService().getUserUnusedVouchers(
        accessToken: _token,
        page: 1,
        limit: 20,
      );

      if (_unusedVoucherResponse.statusCode >= 200 &&
          _unusedVoucherResponse.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_unusedVoucherResponse.body);
        print("MY UNUSED VOUCHERS  ::: ${data['vouchers']}");
        _controller.userUnusedVouchers.value = data['vouchers'];
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _onItemTapped(int index) {
    _controller.selectedIndex.value = index;
  }

  @override
  void didChangeDependencies() {
    _controller.onInit();
    super.didChangeDependencies();
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
                    selectedItemColor: Theme.of(context).colorScheme.secondary,
                    unselectedItemColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    unselectedLabelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    type: BottomNavigationBarType.fixed,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/home_icon.svg",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: 'Home',
                        activeIcon: SvgPicture.asset(
                          "assets/images/home_icon.svg",
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/voucher_icon.svg",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: 'My Vouchers',
                        activeIcon: SvgPicture.asset(
                          "assets/images/voucher_icon.svg",
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/settings_icon.svg",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: 'Settings',
                        activeIcon: SvgPicture.asset(
                          "assets/images/settings_icon.svg",
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/profile_icon.svg",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: 'Profile',
                        activeIcon: SvgPicture.asset(
                          "assets/images/profile_icon.svg",
                          color: Theme.of(context).colorScheme.secondary,
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
      HomePage(manager: widget.manager),
      MyVouchersPage(
        manager: widget.manager,
      ),
      SettingsPage(manager: widget.manager),
      ProfilePage(manager: widget.manager),
    ];
  }
}
