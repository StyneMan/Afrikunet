import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:intl/intl.dart";
import 'package:money_formatter/money_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Constants {
  static const Color primaryColor = Color(0xFF015AB1);
  static const Color accentColor = Color(0xFF6ABB02);
  static const Color secondaryColor = Color(0xFF06396A);

  static const Color primaryColor2 = Color(0xFF111111);
  static const Color accentColor2 = Color(0xFF6ABB02);
  static const Color secondaryColor2 = Color(0xFF000000);

  static const Color golden = Color(0xFFF1A038);
  static const Color strokeColor = Color.fromRGBO(191, 191, 191, 0.7);

  static const double padding = 20;
  static const double avatarRadius = 60;

  static const Color shimmerBaseColor = Color.fromARGB(255, 203, 203, 203);
  static const Color shimmerHighlightColor = Colors.white;

  static const baseURL =
    "http://192.168.165.247:3000/bkapi"; //  "https://afrikunet-api-orcin.vercel.app/bkapi"; // 
  static String pstk = "pk_test_40f544aec0415695c9fae0ba0819ee5bebcb6a5e";

  static String formatMoney(int amt) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: double.parse("${amt}.00"),
      settings: MoneyFormatterSettings(
        symbol: 'NGN',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 3,
        compactFormatType: CompactFormatType.short,
      ),
    );
    return fmf.output.withoutFractionDigits;
  }

  static String formatMoneyFloat(double amt) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: amt,
      settings: MoneyFormatterSettings(
        symbol: 'NGN',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 3,
        compactFormatType: CompactFormatType.short,
      ),
    );
    return fmf.output.withoutFractionDigits;
  }

  static nairaSign(context) {
    Locale locale = Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format;
  }

  static toast(String message) {
    Fluttertoast.showToast(
      msg: "" + message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

// AnimationController localAnimationController;
  static toastify({
    required context,
    required String message,
    required String type,
    required bool persistent,
  }) {
    showTopSnackBar(
      context,
      type == "info"
          ? CustomSnackBar.info(
              message: message,
            )
          : type == "success"
              ? CustomSnackBar.success(
                  message: message,
                )
              : CustomSnackBar.error(
                  message: message,
                ),
      persistent: persistent,
      // onAnimationControllerInit: (controller) =>
      //     localAnimationController = controller,
    );
  }

  //Account Page
  static final accScaffoldKey = GlobalKey<ScaffoldState>();
  static const riKey2 = const Key('__RIKEY2__');
  static final riKey3 = const Key('__RIKEY3__');

  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write("ff");
    buffer.write(hexString.replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool loadingHashSign = true}) => "";
}
