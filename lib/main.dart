// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:afrikunet/screens/onboarding/onboarding.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/helper/theme/app_theme.dart';
import 'package:afrikunet/screens/network/no_internet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'helper/socket/socket_manager.dart';

Future initFirebase() async {
  await Firebase.initializeApp();
}

enum Version { lazy, wait }

// Cmd-line args/Env vars: https://stackoverflow.com/a/64686348/2301224
const String version = String.fromEnvironment('VERSION');
const Version running = version == "lazy" ? Version.lazy : Version.wait;

class GlobalBindings extends Bindings {
  // final LocalDataProvider _localDataProvider = LocalDataProvider();
  @override
  void dependencies() {
    Get.lazyPut<StateController>(() => StateController(), fenix: true);
    // Get.put<StateController>(StateController(), permanent: true);
    // Get.put<LocalDataProvider>(_localDataProvider, permanent: true);
    // Get.put<LocalDataSource>(LocalDataSource(_localDataProvider),
    // permanent: true);
  }
}

/// Calling [await] dependencies(), your app will wait until dependencies are loaded.
class AwaitBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StateController>(() async {
      Dao _dao = await Dao.createAsync();
      return StateController(myDao: _dao);
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Set the status bar color
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white, // Set your desired color here
  //     statusBarIconBrightness:
  //         Brightness.dark, // Set the status bar icons' color
  //   ),
  // );

  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.bottom],
  // );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = Get.put(StateController());
  Widget? component;
  PreferenceManager? _manager;
  bool _authenticated = false;

  _init() async {
    // print("FROM MAIN DART ::::");
    try {
      final _prefs = await SharedPreferences.getInstance();
      _authenticated = _prefs.getBool("loggedIn") ?? false;
    } catch (e) {}
  }

  void _connectSocket() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";
      final _user = _prefs.getString("user") ?? "";
      Map<String, dynamic> _userMap = jsonDecode(_user);

      // socket = IO.io('${Constants.baseURL}/', <String, dynamic>{
      //   "transports": ["websocket"],
      //   "autoConnect": false
      // });

      final socket = SocketManager().socket;
      // socket.connect();
      // socket.on
      socket.onConnect((data) => print('Connected ID: ${data}'));

      if (_token.isNotEmpty) {
        socket.emit('identity', _userMap['id']);
      }

      socket.on(
        "FromAPI",
        (data) => debugPrint("DATA FROM SERVER >> $data"),
      );

      socket.on(
        "new-chat",
        (data) => debugPrint("DATA FROM CHAT >> $data"),
      );

      socket.on(
        "new-review",
        (data) {
          debugPrint("DATA FROM  REVIEW NOW !!! >> ${jsonEncode(data)}");
          // debugPrint("USER ID >> ${data['userId']}");
          if (data['data']['email'] == _userMap['email']) {
            //For me
            debugPrint("FOR ME !! ");
            _prefs.setString('user', data['data']);
            _controller.userData.value = data['data'];
          } else {
            // Not for me
            debugPrint("NOT FOR ME !! ");
          }
        },
      );

      socket.on(
        "review-updated",
        (data) {
          debugPrint("DATA FROM  REVIEW NOW !!! >> ${jsonEncode(data)}");
          // debugPrint("USER ID >> ${data['userId']}");
          if (data['data']['email'] == _userMap['email']) {
            //For me
            debugPrint("FOR ME !! ");
            _prefs.setString('user', data['data']);
            _controller.userData.value = data['data'];
          } else {
            // Not for me
            debugPrint("NOT FOR ME !! ");
          }
        },
      );

      socket.on(
        "review-reply",
        (data) {
          debugPrint("DATA FROM REVIEW REPLY !!! >> ${jsonEncode(data)}");
          // debugPrint("USER ID >> ${data['userId']}");
          if (data['data']['email'] == _userMap['email']) {
            //For me
            debugPrint("FOR ME !! ");
            _prefs.setString('user', data['data']);
            _controller.userData.value = data['data'];
          } else {
            // Not for me
            debugPrint("NOT FOR ME !! ");
          }
        },
      );

      socket.on(
        "isOnline",
        (data) => debugPrint("DATA FROM  >> $data"),
      );

      socket.on(
        "job-posted",
        (data) {
          debugPrint("JOB POSTED NOW!! >> $data");
          _controller.onInit();
        },
      );

      socket.on(
        "job-application-accepted",
        (data) {
          debugPrint("DATA FROM APPLICATION ACCEPTANCE !!! >> ${data}");
          // debugPrint("USER ID >> ${data['userId']}");
          if (data['applicant']['email'] == _userMap['email']) {
            //For me
            debugPrint("FOR ME !! ");
            // fetchDataStream();
            // _prefs.setString('user', data['data']);
            // _controller.userData.value = data['data'];
          } else {
            // Not for me
            debugPrint("NOT FOR ME !! ");
          }
        },
      );

      socket.on(
        "job-application",
        (data) {
          // debugPrint("DATA FROM JOB APPLICATION >> $data");
          if (data['job']['recruiter']['id'] == _userMap['id']) {
            //UPDate here
            // debugPrint("TIRGGER HERE -->>");
            _controller.onInit();
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
    _init();
    _connectSocket();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AfriKunet',
            theme: appTheme,
            home: Scaffold(
              body: Splash(
                controller: _controller,
              ),
            ),
          );
        } else {
          // Loading is done, return the app:
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AfriKunet',
            theme: appTheme,
            home: _controller.hasInternetAccess.value
                ? !_authenticated
                    ? const Onboarding()
                    : Dashboard()
                : const NoInternet(),
          );
        }
      },
    );
  }
}

class Splash extends StatefulWidget {
  var controller;
  Splash({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _init() async {
    try {
      // await FirebaseFirestore.instance.collection("stores").snapshots();
    } on SocketException catch (io) {
      widget.controller.setHasInternet(false);
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Container(
      color: lightMode ? Constants.primaryColor : const Color(0xff042a49),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}

class Dao {
  String dbValue = "";

  Dao._privateConstructor();

  static Future<Dao> createAsync() async {
    var dao = Dao._privateConstructor();
    // print('Dao.createAsync() called');
    return dao._initAsync();
  }

  /// Simulates a long-loading process such as remote DB connection or device
  /// file storage access.
  Future<Dao> _initAsync() async {
    dbValue =
        await Future.delayed(const Duration(seconds: 5), () => 'Some DB data');
    // print('Dao._initAsync done');
    return this;
  }
}
