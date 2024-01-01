import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'voucher_code.dart';

class RedeemVoucher extends StatefulWidget {
  const RedeemVoucher({Key? key}) : super(key: key);

  @override
  State<RedeemVoucher> createState() => _RedeemVoucherState();
}

class _RedeemVoucherState extends State<RedeemVoucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
        ),
        title: TextMedium(
          text: "Redeem Voucher",
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset("assets/images/money_bank.png"),
                  const SizedBox(height: 24.0),
                  TextLarge(
                    text: "Redeem your voucher via scanning or code",
                    align: TextAlign.center,
                    color: const Color(0xFF262626),
                  ),
                  const SizedBox(height: 10.0),
                  TextBody1(
                    text: "Your choice, Your Purchase. Quick and easy",
                    align: TextAlign.center,
                    color: const Color(0xFF5D5D5D),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          buttonText: "Scan",
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: SecondaryButton(
                          buttonText: "Enter Code",
                          onPressed: () {
                            Get.to(
                              VoucherCode(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
