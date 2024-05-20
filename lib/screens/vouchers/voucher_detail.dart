import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/cards/giftcard_item.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VoucherDetail extends StatelessWidget {
  var data;
  VoucherDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

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
              text: "Voucher Information",
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
            SizedBox(
              height: 225,
              child: GiftCardItem(
                amount: "${data['amount']}",
                bgType: data['bg_type'],
                code: data['code'],
                status: data['status'],
                type: data['type'],
                width: double.infinity,
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
                  text: "${data['redeemed_at']}".isEmpty
                      ? "Not redeemed"
                      : "${data['redeemed_at']}",
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
                  text: "${data['status']}".capitalize,
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
                  text: "${data['type']}",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      buttonText: "Copy Code",
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: '${data['code']}'),
                        );
                        Constants.toast('Code copied to clipboard!');
                      },
                      startIcon: const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      fontSize: 16,
                      buttonText: "Share",
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {},
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
