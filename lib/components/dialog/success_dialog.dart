import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'info_dialog.dart';

class Dialogs {
  static showSuccessDialog({required context, required message}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                SvgPicture.asset("assets/images/check_all.svg"),
                const SizedBox(height: 10.0),
                TextSmall(
                  text: " $message",
                  align: TextAlign.center,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: PrimaryButton(
                    buttonText: "Done",
                    fontSize: 15,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
