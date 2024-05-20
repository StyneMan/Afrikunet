import 'dart:io';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/custom_dialog.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:intl/intl.dart";
import 'package:money_formatter/money_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class Constants {
  static const Color primaryColor = Color(0xFF015AB1);
  static const Color accentColor = Color(0xFF4B9EF2);
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
      "http://192.168.43.41:3050/bkapi"; // "https://afrikunet-api-orcin.vercel.app/bkapi"; //

  static const baseURL2 =
      "http://192.168.43.41"; // "https://afrikunet-api-orcin.vercel.app"; //

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

  static String timeUntil(DateTime date) {
    return timeago
        .format(date, locale: "en", allowFromNow: true)
        .replaceAll("minute", "min")
        .replaceAll("second", "sec")
        .replaceAll("hour", "hr")
        .replaceAll("a moment ago", "just now")
        .replaceAll("from now", "ago")
        .replaceAll("about", "");
  }

  static String formatDate(String date) {
    final d = DateTime.parse(date);
    return DateFormat('dd MMM, yyyy').format(d);
  }

  static String getFlagEmojiFromISO3(String iso3) {
    const int baseOffset = 127397; // Offset for regional indicator symbols
    final String countryCode = iso3.toUpperCase();
    String flag = '';
    for (int i = 0; i < countryCode.length; i++) {
      flag += String.fromCharCode(baseOffset + countryCode.codeUnitAt(i));
      // flag += String.fromCharCode(countryCode.codeUnitAt(i) + baseOffset);
    }
    print("FLAG HERE ::: $flag");
    return flag.replaceAll(RegExp(r'[A-Z]'), '');
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

  static String getCurrency(String code) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: 0,
      settings: MoneyFormatterSettings(
        symbol: code,
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 3,
        compactFormatType: CompactFormatType.short,
      ),
    );
    return fmf.output.withoutFractionDigits
        .replaceAll('0', '')
        .replaceAll('.', '');
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

  static showInfoDialog(
      {required var context, required var message, required var status}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                status == "success"
                    ? Icon(
                        CupertinoIcons.info_circle,
                        size: 84,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 84,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextMedium(
                    text: "$message".replaceAll("_", " "),
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400,
                    align: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
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

  static showSuccessDialog({
    required var context,
    required String title,
    required String message,
  }) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.98,
          child: CustomDialog(
            ripple: SvgPicture.asset(
              "assets/images/check_effect.svg",
              width: (Constants.avatarRadius + 20),
              height: (Constants.avatarRadius + 20),
            ),
            avtrBg: Colors.transparent,
            avtrChild: Image.asset(
              "assets/images/checked.png",
            ), //const Icon(CupertinoIcons.check_mark, size: 50,),
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
                    text: title,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextSmall(
                    text: message,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                    child: PrimaryButton(
                      buttonText: "Close",
                      foreColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  static showErrorDialog({
    required var context,
    required var message,
    required Widget widget,
    required bool dismissible,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32.0),
                Icon(
                  CupertinoIcons.info_circle_fill,
                  size: 84,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 10.0),
                TextMedium(
                  text: "$message",
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w400,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                widget,
                const SizedBox(
                  height: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
