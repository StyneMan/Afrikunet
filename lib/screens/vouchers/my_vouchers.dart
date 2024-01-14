import 'package:afrikunet/components/cards/my_giftcard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/giftcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) => SizedBox(
          child: MyGiftCard(data: tempGiftCards[index]),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 24.0),
        itemCount: tempGiftCards.length,
      ),
    );
  }
}
