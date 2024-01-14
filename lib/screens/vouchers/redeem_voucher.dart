import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            TextMedium(
              text: "Redeem Voucher",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
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
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 10.0),
                  TextBody1(
                    text: "Your choice, Your Purchase. Quick and easy",
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          buttonText: "Scan",
                          bgColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: SecondaryButton(
                          buttonText: "Enter Code",
                          foreColor: Theme.of(context).colorScheme.secondary,
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
