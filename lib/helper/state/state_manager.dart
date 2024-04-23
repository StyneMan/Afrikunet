import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../preference/preference_manager.dart';

class StateController extends GetxController {
  Dao? myDao;

  StateController({this.myDao});

  PreferenceManager? manager;

  var isAppClosed = false;
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var hideNavbar = false.obs;
  var hasInternetAccess = true.obs;
  var isLoadingPackages = true.obs;

  var onboardingIndex = 0.obs;
  var cableTvAmount = 0.0.obs;
  var internetDataAmount = 0.0.obs;
  var cableTvPackageName = "".obs;
  var electricityDistributorName = "".obs;

  var vtus = [].obs;
  var internetData = {}.obs;
  var airtimeData = {}.obs;
  var electricityData = {}.obs;
  var cableData = {}.obs;

  var selectedAirtimeNetwork = {}.obs;

  var selectedDataNetwork = {}.obs;
  var selectedDataPlan = {}.obs;

  var selectedCableNetwork = {}.obs;
  var selectedCableBouquet = {}.obs;

  var croppedPic = "".obs;
  var customSearchBar = [].obs;
  var usersVoucherSplit = [].obs;
  var userHistory = [].obs;
  var banks = [].obs;
  var selectedContact = {}.obs;

  var userData = {}.obs;

  RxString currentThemeMode = "light".obs;

  ScrollController transactionsScrollController = ScrollController();
  ScrollController messagesScrollController = ScrollController();

  var accessToken = "".obs;
  String _token = "";
  RxString dbItem = 'Awaiting data'.obs;

  final Connectivity _connectivity = Connectivity();

  Future<void> initDao() async {
    // instantiate Dao only if null (i.e. not supplied in constructor)
    myDao = await Dao.createAsync();
    dbItem.value = myDao!.dbValue;
  }

  _init() async {
    try {
      final response = await APIService().getVTUs();
      debugPrint("PRODUCT RESP:: ${response.body}");
      setHasInternet(true);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        // ProductResponse body = ProductResponse.fromJson(map);
        setVtus(map['data']);

        map['data']?.forEach((elem) => {
              if (elem['name'].toString().toLowerCase() == "airtime")
                {airtimeData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "data")
                {internetData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "electricity")
                {electricityData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "cable_tv")
                {cableData.value = elem}
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    initDao();

    final _prefs = await SharedPreferences.getInstance();
    var user = _prefs.getString("user") ?? "{}";
    var _token = _prefs.getString("accessToken") ?? "";
    print("ACCCESS TOKENN ::: $_token");
    Map<String, dynamic> map = jsonDecode(user);
    // debugDebugPrintdebugPrint("US EMIA >> ${map['email']}");

    _init();

    if (_token.isNotEmpty) {
      //Get User Profile
      APIService().getProfile(_token).then((value) {
        // debugDebugPrintdebugPrint("STATE GET PROFILE >>> ${value.body}");
        Map<String, dynamic> data = jsonDecode(value.body);
        print("USER PROFILE  ::: ${data['user']}");
        userData.value = data['user'];
        _prefs.setString("user", jsonEncode(data['user']));

        //Update preference here
      }).catchError((onError) {
        debugPrint("STATE GET PROFILE ERROR >>> $onError");
        if (onError.toString().contains("rk is unreachable")) {
          hasInternetAccess.value = false;
        }
      });

      //Get User Profile
      APIService().getHistory(_token).then((value) {
        Map<String, dynamic> data = jsonDecode(value.body);
        print("HISTORY  ::: ${data['data']}");
        userHistory.value = data['data'];
      }).catchError((onError) {
        debugPrint("STATE GET PROFILE ERROR >>> $onError");
        if (onError.toString().contains("rk is unreachable")) {
          hasInternetAccess.value = false;
        }
      });
    }
  }

  Widget currentScreen = const SizedBox();

  var currentPage = "Home";
  List<String> pageKeys = [
    "Home",
    "Categories",
    "Promos",
    "Services",
    "Account"
  ];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Categories": GlobalKey<NavigatorState>(),
    "Promos": GlobalKey<NavigatorState>(),
    "Services": GlobalKey<NavigatorState>(),
    "Account": GlobalKey<NavigatorState>(),
  };

  var selectedIndex = 0.obs; //Bottom Navigation Dashboard tab

  setUserData(var value) {
    if (value != null) {
      userData.value = value;
    }
  }

  clearTempProfile() {}

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  void setHasInternet(bool state) {
    hasInternetAccess.value = state;
  }

  void setVtus(var state) {
    vtus.value = state;
  }

  void jumpTo(int pos) {
    // tabController.jumpToTab(pos);
  }

  setLoading(bool state) {
    isLoading.value = state;
  }

  void resetAll() {}

  @override
  void onClose() {
    super.onClose();
    transactionsScrollController.dispose();
    messagesScrollController.dispose();
  }
}
