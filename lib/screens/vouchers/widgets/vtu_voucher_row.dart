import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class VTUVoucherRow extends StatelessWidget {
  var item;
  VTUVoucherRow({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Get.to(
        //   VoucherDetail(data: item),
        //   transition: Transition.cupertino,
        // );
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
                SizedBox(
                  width: 140,
                  height: 96,
                  child: MicroGiftCard(
                    amount: "${item['amount']}",
                    bgType: item['bg_type'],
                    code: item['code'],
                    status: item['status'],
                    type: item['type'],
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSmall(
                      text:
                          "Voucher  ${item['code'].toString().substring(0, 4)}****",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    TextBody2(
                      text:
                          "${Constants.formatDate("${item['created_at']}")} (${Constants.timeUntil(DateTime.parse(item['created_at']))})",
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
