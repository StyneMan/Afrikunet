import 'package:afrikunet/components/cards/giftcard_mini.dart';
import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/cards/micro_vouchercard.dart';
import 'package:afrikunet/components/cards/my_giftcard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/giftcards.dart';
import 'package:afrikunet/screens/vouchers/voucher_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyVouchersPage extends StatelessWidget {
  const MyVouchersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextMedium(
              text: "My Vouchers",
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SvgPicture.asset("assets/images/mi_voucher.svg"),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(1.0),
          itemBuilder: (context, index) => TextButton(
            onPressed: () {
              Get.to(
                const VoucherDetail(),
                transition: Transition.cupertino,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      tempMyCards[index].cardType == "gift card"
                          ? SizedBox(
                              width: 125,
                              height: 82,
                              child: MicroGiftCard(
                                amount: "4 units",
                                bgImage: tempMyCards[index].bgImage,
                                code: tempMyCards[index].code,
                                logo: tempMyCards[index].logo,
                                type: tempMyCards[index].type,
                              ),
                            )
                          : SizedBox(
                              width: 125,
                              height: 82,
                              child: MicroVoucherCard(
                                amount: "4 units",
                                bgImage: tempMyCards[index].bgImage,
                                code: tempMyCards[index].code,
                                logo: tempMyCards[index].logo,
                                type: tempMyCards[index].type,
                                event: "${tempMyCards[index].event}",
                              ),
                            ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMedium(
                            text: "Voucher  XSE4F4******",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          TextBody2(
                            text: "Dec 10, 2023",
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          separatorBuilder: (context, index) => const Column(
            children: [
              SizedBox(height: 16.0),
              Divider(),
              SizedBox(height: 16.0),
            ],
          ),
          itemCount: tempMyCards.length,
        ),
      ),
    );
  }
}
