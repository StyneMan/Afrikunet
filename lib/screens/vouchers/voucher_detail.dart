import 'package:afrikunet/components/cards/giftcard_item.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoucherDetail extends StatelessWidget {
  const VoucherDetail({Key? key}) : super(key: key);

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
              text: "My Voucher",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 10.0),
            const SizedBox(
              height: 225,
              child: GiftCardItem(
                amount: "4 units",
                bgImage: "assets/images/giftcard_bg.png",
                code: "123mjksjk43",
                logo: "assets/images/afrikunet_logo_white.png",
                type: "blue",
              ),
            ),
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextSmall(
                  text: "Date Redeemed: ",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                TextSmall(
                  text: "12-03-2024",
                  color: Theme.of(context).colorScheme.tertiary,
                )
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextSmall(
                  text: "Status: ",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                TextSmall(
                  text: "Used",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextSmall(
                  text: "Voucher Type",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                TextSmall(
                  text: "Marriage",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
