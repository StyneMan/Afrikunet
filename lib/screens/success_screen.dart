import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'pdf/pdf_preview.dart';

class SuccessPage extends StatelessWidget {
  final PreferenceManager manager;
  final bool isVoucher;
  final String message;
  const SuccessPage({
    Key? key,
    this.isVoucher = false,
    required this.manager,
    this.message = "",
  }) : super(key: key);

  final String imageUrl = 'assets/images/temp_giftcard.png';
  final String sharedText = 'Visit our site:: https://afrikunet.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/giftcard_bg.png"),
            fit: BoxFit.contain,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/thumbs_up.svg"),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextLarge(
                    text: "Congratulations",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  !isVoucher
                      ? TextSmall(
                          text: "Your purchase is successful",
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: TextSmall(
                            text: message,
                            color: Theme.of(context).colorScheme.tertiary,
                            align: TextAlign.center,
                          ),
                        ),
                ],
              ),
            ),
            // isVoucher
            //     ? Expanded(
            //         flex: 2,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             SizedBox(
            //               width: double.infinity,
            //               child: PrimaryButton(
            //                 onPressed: () {
            //                   Get.off(
            //                     Dashboard(),
            //                     transition: Transition.cupertino,
            //                   );
            //                 },
            //                 fontSize: 16,
            //                 buttonText: "Done",
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     :
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                    fontSize: 16,
                    buttonText: "Share",
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      Share.share('$sharedText\n$imageUrl');
                      // Share.share(
                      //     'Visit our site:: https://afrikunet.com/');
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SecondaryButton(
                    fontSize: 15,
                    buttonText: "Download",
                    foreColor: Theme.of(context).colorScheme.inverseSurface,
                    onPressed: () {
                      Get.to(
                        const PDFPreview(),
                        transition: Transition.cupertino,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.off(
                        Dashboard(
                          manager: manager,
                        ),
                        transition: Transition.cupertino,
                      );
                    },
                    child: TextMedium(
                      text: "Done",
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
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
