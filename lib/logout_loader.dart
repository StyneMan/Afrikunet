import 'dart:io';

import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/getstarted/getstarted.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class LogoutLoader extends StatefulWidget {
  const LogoutLoader({Key? key}) : super(key: key);

  @override
  State<LogoutLoader> createState() => _LogoutLoaderState();
}

class _LogoutLoaderState extends State<LogoutLoader> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const GetStarted(),
        ),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: true,
      progressIndicator: Platform.isAndroid
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const CupertinoActivityIndicator(
              animating: true,
            ),
      backgroundColor: Colors.black54,
      child: Container(
        color: Constants.primaryColor,
      ),
    );
  }
}
