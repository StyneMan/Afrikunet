import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dashboard/dashboard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SuccessPage extends StatelessWidget {
  final bool isVoucher;
  const SuccessPage({
    Key? key,
    this.isVoucher = false,
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
            image: AssetImage("assets/images/success_bg.png"),
            fit: BoxFit.cover,
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
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  !isVoucher
                      ? TextSmall(
                          text: "Your voucher purchase is successful",
                          color: const Color(0xFF7D7D7D),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: TextSmall(
                            text:
                                "You have successfully redeemed your voucher to GTB with account number 23347***90",
                            color: const Color(0xFF7D7D7D),
                            align: TextAlign.center,
                          ),
                        ),
                ],
              ),
            ),
            isVoucher
                ? Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: () {
                              Get.off(
                                Dashboard(),
                                transition: Transition.cupertino,
                              );
                            },
                            fontSize: 16,
                            buttonText: "Done",
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          fontSize: 18,
                          buttonText: "Share",
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
                          fontSize: 18,
                          buttonText: "Download",
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.off(
                              Dashboard(),
                              transition: Transition.cupertino,
                            );
                          },
                          child: TextMedium(
                            text: "Done",
                            fontWeight: FontWeight.w600,
                            color: Constants.primaryColor,
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
